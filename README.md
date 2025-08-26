# Linux_Setup

[![License](https://img.shields.io/badge/License-All%20Rights%20Reserved-red.svg)](./LICENSE)
[![Author](https://img.shields.io/badge/Author-Matthew%20Stdenis-blue.svg)](mailto:matthew.h.stdenis@gmail.com)
[![Status](https://img.shields.io/badge/Status-Private%20Repository-orange.svg)](https://github.com/6r1zzlyB/Linux_Setup)
[![Technology](https://img.shields.io/badge/Shell-Bash-green.svg)](https://www.gnu.org/software/bash/)
[![Platform](https://img.shields.io/badge/Platform-Debian%20%7C%20Ubuntu-blue.svg)](https://www.debian.org/)

A comprehensive automated setup script for Debian/Ubuntu-based Linux servers. This script handles the complete initial configuration of a fresh server installation, from essential package installation to user management and optional services.

**Author:** Matthew Stdenis
**Created:** 2025
**License:** All Rights Reserved (see [LICENSE](./LICENSE))

**IMPORTANT:** This repository is confidential and intended for personal use only. It is strictly forbidden to share any part of this repository with any third party without written consent from Matthew Stdenis.

## 🚨 Important Legal Notice

**This software is proprietary and protected by copyright law.** 

- **Viewing and Reference**: You may view this code for reference and learning purposes
- **Usage Restrictions**: Any use beyond viewing requires explicit written permission from the copyright owner
- **No Distribution**: You may not copy, distribute, or create derivative works without permission
- **Commercial Use**: Commercial use is strictly prohibited without explicit permission

For licensing inquiries or permission requests, please contact the repository owner.

## 🚀 Quick Start

### Download and Run (One-liner)

```bash
# Basic setup
curl -fsSL https://raw.githubusercontent.com/6r1zzlyB/Linux_Setup/main/server-setup.sh | sudo bash

# With options (create user and install VM tools)
curl -fsSL https://raw.githubusercontent.com/6r1zzlyB/Linux_Setup/main/server-setup.sh | sudo bash -s -- --create-user admin --install-vm-tools
```

### Manual Download and Execute

```bash
# Download the script
wget https://raw.githubusercontent.com/6r1zzlyB/Linux_Setup/main/server-setup.sh

# Make it executable
chmod +x server-setup.sh

# Run with desired options
sudo ./server-setup.sh --create-user admin --install-cockpit
```

## 📋 What This Script Does

### Core Components (Always Installed)
- ✅ **System Updates**: Updates all packages to latest versions
- ✅ **Essential Packages**: Installs development tools, network utilities, and system monitoring tools
- ✅ **sudo Package**: Installs sudo (required for Debian minimal installations)
- ✅ **PATH Configuration**: Fixes root user PATH environment for proper system tool access
- ✅ **Unattended Upgrades**: Configures automatic security updates
- ✅ **Custom MOTD**: Sets up informative system information display on login
- ✅ **Oh My Zsh**: Installs enhanced shell environment (optional)

### Optional Components
- 🔧 **User Management**: Create users and configure sudo access
- 🌐 **Cockpit**: Web-based server management interface
- 💾 **NFS Mount**: Network file system mounting with auto-mount
- 🖥️ **VM Tools**: VMware integration tools (open-vm-tools)

## 🛠️ Installation Options

### Basic Setup
```bash
# Minimal installation with defaults
sudo ./server-setup.sh
```

### User Management
```bash
# Create a new user with sudo access
sudo ./server-setup.sh --create-user admin

# Configure existing user for sudo access
sudo ./server-setup.sh --setup-sudo-user john
```

### Environment-Specific Setups

#### VMware/ESXi Environment
```bash
sudo ./server-setup.sh --create-user admin --install-vm-tools --install-cockpit
```

#### XCP-ng/Citrix Hypervisor
```bash
sudo ./server-setup.sh --create-user admin --install-cockpit
```

#### Bare Metal Server
```bash
sudo ./server-setup.sh --create-user admin --setup-nfs --install-cockpit
```

#### Proxmox VE Guest
```bash
sudo ./server-setup.sh --create-user admin --install-cockpit
```

### Advanced Configuration
```bash
# Full setup with custom NFS configuration
sudo ./server-setup.sh \
    --create-user admin \
    --install-cockpit \
    --setup-nfs \
    --nfs-server 192.168.1.20 \
    --nfs-path /volume2/data \
    --nfs-mount-point /data \
    --install-vm-tools
```

## 📖 Command Line Options

| Option | Description | Example |
|--------|-------------|---------|
| `--create-user USERNAME` | Create new user account with sudo access | `--create-user admin` |
| `--setup-sudo-user USERNAME` | Add existing user to sudo group | `--setup-sudo-user john` |
| `--install-cockpit` | Install Cockpit web management interface | `--install-cockpit` |
| `--install-vm-tools` | Install open-vm-tools for VMware environments | `--install-vm-tools` |
| `--setup-nfs` | Configure NFS network mount | `--setup-nfs` |
| `--nfs-server SERVER` | NFS server IP address (default: 192.168.1.10) | `--nfs-server 192.168.1.20` |
| `--nfs-path PATH` | NFS export path (default: /volume1/SNAS) | `--nfs-path /volume2/data` |
| `--nfs-mount-point DIR` | Local mount directory (default: /nas) | `--nfs-mount-point /data` |
| `--skip-zsh` | Skip Oh My Zsh installation | `--skip-zsh` |
| `--help` | Display help information | `--help` |

## 📦 Installed Packages

### Essential System Tools
- **sudo** - Superuser privileges management
- **curl, wget** - Download utilities  
- **git** - Version control system
- **nano** - Text editor
- **htop** - System process viewer
- **tree** - Directory structure display
- **figlet, lolcat** - Text formatting utilities

### Network & System Utilities  
- **net-tools** - Network configuration tools (ifconfig, etc.)
- **dnsutils** - DNS lookup utilities (nslookup, dig)
- **iputils-ping** - Network connectivity testing
- **ipcalc** - IP address calculations

### Development & Monitoring
- **screen** - Terminal multiplexer
- **zsh** - Advanced shell (with Oh My Zsh)
- **apt-show-versions** - Package version information
- **landscape-common** - System information tools
- **bc** - Calculator for system calculations

### System Maintenance
- **unattended-upgrades** - Automatic security updates
- **apt-listchanges** - Package change notifications

## 🖥️ Optional Services

### Cockpit Web Interface
- **Access**: `https://SERVER_IP:9090`
- **Features**: System monitoring, service management, terminal access, file management
- **Authentication**: Uses system user accounts

### NFS Network Storage
- **Auto-mount**: Configured to mount on boot via crontab
- **Persistence**: Added to `/etc/fstab` for permanent mounting
- **Performance**: Optimized with large buffer sizes (1MB read/write)

## 🔧 System Configuration

### Custom MOTD (Message of the Day)
Displays comprehensive system information on login:
- Hostname and IP address
- OS distribution and kernel version
- System uptime and load averages
- CPU and memory information
- Running processes breakdown
- Available package updates

### Root User PATH Fix
Configures proper PATH environment for root user:
```bash
/usr/local/sbin:/usr/sbin:/sbin:/usr/local/bin:/usr/bin:/bin
```
This ensures all system administration tools are accessible.

### Oh My Zsh Configuration
- Installed for root and specified user accounts
- Provides enhanced shell experience with themes and plugins
- Configured with sensible defaults

## 🔒 Security Considerations

- **User Creation**: New users are created with secure home directories
- **Sudo Access**: Users added to sudo group (standard approach)
- **No Passwordless Sudo**: Password required for elevated privileges (security best practice)
- **Unattended Upgrades**: Automatic security updates enabled
- **System Hardening**: Essential security tools and configurations applied

## 🌍 Platform Compatibility

### Supported Operating Systems
- ✅ **Debian 10** (Buster)
- ✅ **Debian 11** (Bullseye) 
- ✅ **Debian 12** (Bookworm)
- ✅ **Ubuntu 18.04 LTS** (Bionic)
- ✅ **Ubuntu 20.04 LTS** (Focal)
- ✅ **Ubuntu 22.04 LTS** (Jammy)
- ✅ **Ubuntu 24.04 LTS** (Noble)

### Virtualization Platforms
- **VMware ESXi/vSphere** (use `--install-vm-tools`)
- **Proxmox VE** (VM tools not needed)
- **XCP-ng/Citrix Hypervisor** (uses xe-guest-utilities)
- **VirtualBox** (VM tools not needed)
- **Bare Metal** (no VM tools needed)

## 🚨 Prerequisites

- **Root Access**: Script must be run as root user
- **Internet Connection**: Required for package downloads
- **Fresh Installation**: Designed for newly installed systems
- **Minimum RAM**: 512MB (1GB+ recommended)
- **Disk Space**: At least 2GB free space

## 🔍 Troubleshooting

### Common Issues

#### "Command not found" errors
```bash
# Fix PATH issues (script handles this automatically)
export PATH="/usr/local/sbin:/usr/sbin:/sbin:/usr/local/bin:/usr/bin:/bin:$PATH"
```

#### Package installation failures
```bash
# Update package lists first
apt update
```

#### Permission denied
```bash
# Ensure script is executable and run as root
chmod +x server-setup.sh
sudo ./server-setup.sh
```

#### NFS mount failures
```bash
# Check network connectivity to NFS server
ping YOUR_NFS_SERVER_IP

# Verify NFS server is accessible
showmount -e YOUR_NFS_SERVER_IP
```

### Log Files
Script output provides detailed logging with timestamps and color-coded messages:
- 🟢 **Green**: Successful operations
- 🟡 **Yellow**: Warnings  
- 🔴 **Red**: Errors
- 🔵 **Blue**: Informational messages

## 🤝 Contributing

**Note**: This is a proprietary repository. Contributions are not currently accepted without prior arrangement.

For feature requests or suggestions:
1. Open an issue to discuss the proposed changes
2. Wait for approval before proceeding with any modifications
3. All contributions, if accepted, become the property of Matthew Stdenis

## 📝 License

This project is proprietary software owned by Matthew Stdenis. All rights reserved.

**Copyright © 2025 Matthew Stdenis**

This software is provided for viewing and reference purposes only. Any use beyond viewing requires explicit written permission from the copyright owner. See the [LICENSE](./LICENSE) file for complete terms and conditions.

**UNAUTHORIZED USE IS STRICTLY PROHIBITED AND MAY RESULT IN LEGAL ACTION.**

## 🆘 Support

**Support Policy**: This is proprietary software with limited support availability.

If you encounter issues:
1. Check the [Issues](https://github.com/6r1zzlyB/Linux_Setup/issues) page for existing solutions
2. Open a new issue with detailed information if your problem isn't addressed
3. Include your OS version, exact command used, and error messages
4. **Note**: Support is provided at the discretion of the copyright owner

For licensing inquiries or commercial support, please contact Matthew Stdenis directly.

## 🚀 Roadmap

- [ ] Support for CentOS/RHEL/Rocky Linux
- [ ] Docker container deployment option
- [ ] Configuration file support
- [ ] Firewall configuration options
- [ ] SSL certificate automation
- [ ] Monitoring stack integration (Prometheus/Grafana)

## 📊 Script Statistics

- **Lines of Code**: ~400+
- **Functions**: 12 core functions
- **Supported Packages**: 20+ essential packages
- **Configuration Options**: 9 command-line flags
- **Average Runtime**: 3-5 minutes (depending on options)

---

**⭐ If this script helped you, please consider giving it a star on GitHub!**
