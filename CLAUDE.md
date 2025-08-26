# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a Linux server automation setup script for Debian/Ubuntu systems. The repository contains a single-purpose bash script (`server-setup.sh`) that automates the initial configuration of fresh server installations.

**IMPORTANT**: This is proprietary software owned by Matthew Stdenis. All modifications require explicit permission from the copyright owner.

## Core Architecture

### Script Structure
- **Single monolithic script**: All functionality contained in `server-setup.sh` (~545 lines)
- **Function-based design**: 12 core functions handling specific setup tasks
- **Sequential execution**: Functions called in dependency order via `main()`
- **Configuration variables**: Environment variables at script top control behavior

### Key Components

**Core Functions**:
- `check_root()` - Root privilege validation
- `fix_root_path()` - PATH environment configuration 
- `detect_os()` - Operating system detection
- `update_system()` - Package updates
- `install_essential_packages()` - Core package installation
- `setup_sudo_user()` - User management and sudo configuration
- `install_oh_my_zsh()` - Enhanced shell setup
- `setup_motd()` - Custom login message
- `install_cockpit()` - Web management interface (optional)
- `setup_nfs_mount()` - Network storage mounting (optional)

**Configuration System**:
```bash
# Environment variables control behavior
INSTALL_COCKPIT=${INSTALL_COCKPIT:-false}
SETUP_NFS_MOUNT=${SETUP_NFS_MOUNT:-false}
CREATE_USER=${CREATE_USER:-""}
# ... etc
```

**Command Line Interface**:
- 9 command-line options (--install-cockpit, --create-user, etc.)
- Argument parsing via `while [[ $# -gt 0 ]]` loop
- Comprehensive help system with usage examples

### Package Management
Essential packages are defined in arrays within `install_essential_packages()`:
- System tools: sudo, curl, wget, git, nano, htop, tree
- Network utilities: net-tools, dnsutils, iputils-ping, ipcalc  
- Development: screen, zsh, apt-show-versions
- Security: unattended-upgrades, apt-listchanges

## Common Operations

### Script Execution
```bash
# Basic setup (run as root)
sudo ./server-setup.sh

# Full featured setup
sudo ./server-setup.sh --create-user admin --install-cockpit --install-vm-tools

# NFS configuration
sudo ./server-setup.sh --setup-nfs --nfs-server 192.168.1.20 --nfs-path /volume2/data

# Help and options
sudo ./server-setup.sh --help
```

### Testing the Script
```bash
# Make executable
chmod +x server-setup.sh

# Dry run validation (check syntax)
bash -n server-setup.sh

# Test individual functions (requires sourcing)
source server-setup.sh
check_root  # Will exit if not root
detect_os   # Shows detected OS info
```

### Script Modification Guidelines
- Maintain function-based architecture
- Follow existing error handling patterns using `log()`, `error()`, `warning()`, `info()`
- Use color constants: RED, GREEN, YELLOW, BLUE, CYAN, NC
- Preserve command-line argument parsing structure
- Add new packages to the `packages` array in `install_essential_packages()`

### Key Design Patterns

**Error Handling**:
- `set -euo pipefail` for strict error handling
- Logging functions with timestamps and colors
- Graceful degradation for optional components

**Idempotency**:
- Check existing state before modifications
- Skip operations if already completed (e.g., user exists, package installed)
- Safe to run multiple times

**Security Considerations**:
- Root privilege required (validated at start)
- No passwordless sudo by default
- Secure user creation with proper home directories
- Automatic security updates enabled

## Platform Compatibility

### Supported Systems
- Debian 10-12 (Buster, Bullseye, Bookworm)
- Ubuntu 18.04-24.04 LTS (Bionic, Focal, Jammy, Noble)

### Virtualization Support
- VMware ESXi/vSphere (use `--install-vm-tools`)
- Proxmox VE (VM tools not needed)
- XCP-ng/Citrix Hypervisor (uses xe-guest-utilities)
- Bare metal servers

## Development Notes

### Adding New Features
1. Create new function following existing naming convention
2. Add configuration variable at script top with default value
3. Add command-line argument parsing in the `while` loop
4. Add function call to `main()` in appropriate order
5. Update help text and summary display

### Custom MOTD System
The script creates a comprehensive MOTD at `/etc/update-motd.d/00-motd` that displays:
- System information (hostname, IP, OS, kernel)
- Resource usage (load, memory, processes)
- Hardware details (CPU info)
- Available package updates

### NFS Integration
NFS mounting includes:
- fstab entry for persistence
- Crontab auto-mount on reboot
- Performance optimization (1MB read/write buffers)
- Network dependency handling (`_netdev` option)

## Repository Structure
```
Linux_Setup/
├── server-setup.sh    # Main automation script
├── README.md          # Comprehensive documentation
├── CHANGELOG.md       # Version history and changes
├── LICENSE           # Proprietary license terms
└── CLAUDE.md         # This file
```