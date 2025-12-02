# KeePass Database Cracker

A multithreaded password cracking tool for KeePass database files (.kdbx) using wordlist attacks.

Inspired by [keepass4brute](https://github.com/r3nt0n/keepass4brute) by r3nt0n.

## ⚠️ Educational Purpose Only

**WARNING**: This tool is provided strictly for educational and research purposes. It is designed to help security professionals test the strength of their own KeePass master passwords.

**You must NOT use this tool to:**
- Access KeePass databases without explicit authorization
- Crack passwords for databases you don't own
- Perform any unauthorized or illegal activities

The author assumes no liability for misuse. Users are responsible for ensuring compliance with all applicable laws.

## Features

- **Multithreaded**: Configurable number of parallel processes
- **Progress Tracking**: Real-time password count display
- **Fast**: Process pooling with semaphore synchronization
- **Auto-Stop**: Terminates immediately when password is found

## Requirements

- Bash 4.0+
- `keepassxc-cli`

Install on Ubuntu/Debian:
```bash
sudo apt install keepassxc
```

## Installation

```bash
git clone https://github.com/yourusername/keepass4brute_mt.git
cd keepass4brute_mt
chmod +x keepass4brute_mt.sh
```

## Usage

```bash
./keepass4brute_mt.sh <kdbx-file> <wordlist> [max_procs]
```

**Arguments:**
- `kdbx-file`: Path to KeePass database (.kdbx)
- `wordlist`: Path to wordlist file
- `max_procs`: Number of parallel processes (default: 4)

**Examples:**

```bash
# Default 4 processes
./keepass4brute_mt.sh database.kdbx /usr/share/wordlists/rockyou.txt

# With 8 processes
./keepass4brute_mt.sh database.kdbx /usr/share/wordlists/rockyou.txt 8
```

## Example Output

```
==========================================
  KeePass Database Cracker v1.0
==========================================

[*] Target database: Database.kdbx
[*] Wordlist: /usr/share/wordlists/rockyou.txt
[*] Parallel processes: 8
[*] Starting password cracking...

[*] Tested: 1000 passwords...
============================================
[+] PASSWORD FOUND: welcome1
============================================
```

## Exit Codes

- `0`: Password found
- `1`: Dependency not installed
- `2`: Invalid arguments or file not found
- `3`: Password not found in wordlist

## Performance Tips

- Set processes to your CPU core count or 2× CPU cores
- More processes doesn't always equal faster (I/O limits)
- Use SSDs for better performance

## Legal Notice

This tool is intended exclusively for:
- Testing your own KeePass databases
- Security research with proper authorization
- Educational demonstrations
- Authorized penetration testing

**NEVER** use this tool on databases you don't own or without explicit permission. Unauthorized access is illegal.

## Credits

Inspired by [keepass4brute](https://github.com/r3nt0n/keepass4brute) by r3nt0n.

## License

MIT License

## Disclaimer

The developers are not responsible for any misuse or damage caused by this tool. Use at your own risk and only on databases you have authorization to test.