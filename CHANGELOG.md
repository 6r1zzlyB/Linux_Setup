# Changelog - Linux_Setup

All notable changes to Linux_Setup will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Planned

- Support for CentOS/RHEL/Rocky Linux distributions
- Docker container deployment option
- Configuration file support for custom setups
- Firewall configuration options
- SSL certificate automation
- Monitoring stack integration (Prometheus/Grafana)

## [2.0.0] - 2025-01-15

### Added

- **Enhanced Documentation**: Comprehensive README with detailed installation instructions
- **Command Line Options**: 9 different configuration flags for customized setup
- **Custom MOTD**: Informative system information display on login
- **Oh My Zsh Integration**: Enhanced shell experience with themes and plugins
- **NFS Mount Support**: Automated network file system mounting with persistence
- **VM Tools Support**: VMware open-vm-tools installation for virtualized environments
- **User Management**: Automated user creation and sudo configuration
- **Security Hardening**: Unattended upgrades and security best practices

### Changed

- **Script Architecture**: Modular function-based design for better maintainability
- **Package Selection**: Curated essential packages for server environments
- **Error Handling**: Improved error detection and user feedback
- **Platform Support**: Enhanced compatibility across Debian and Ubuntu versions

### Fixed

- **ROOT PATH Configuration**: Automatic PATH environment fixes for system administration
- **Package Dependencies**: Proper handling of package dependencies and conflicts
- **Permission Issues**: Secure user and file permission configuration

## [1.0.0] - 2024-12-01

### Added

- **Initial Release**: Basic Linux server setup automation
- **Package Installation**: Essential system tools and utilities
- **Cockpit Integration**: Web-based server management interface
- **System Updates**: Automated package updates and security patches
- **Basic Configuration**: Fundamental system configuration setup

### Features

- **Multi-Platform Support**: Debian and Ubuntu compatibility
- **Essential Packages**: 20+ core system packages
- **Web Management**: Cockpit integration for remote administration
- **Security Updates**: Automatic security patch installation
- **Basic User Setup**: Simple user account management

---

## Version Numbering Guidelines

### Semantic Versioning (MAJOR.MINOR.PATCH)

- **MAJOR (X.0.0)**: Incompatible API changes or major functionality changes
- **MINOR (0.Y.0)**: New functionality added in a backwards-compatible manner
- **PATCH (0.0.Z)**: Backwards-compatible bug fixes

### Date Format

- Use ISO 8601 format: YYYY-MM-DD
- Example: 2025-01-15

### Change Categories

#### Added
- New features and functionality
- New capabilities and integrations
- New configuration options
- New documentation sections

#### Changed
- Changes to existing functionality
- Improvements to existing features
- Updates to existing processes
- Modifications to existing behavior

#### Fixed
- Bug fixes and corrections
- Error resolutions and patches
- Issue solutions and workarounds
- Performance improvements

#### Removed
- Removed features and functionality
- Deprecated capabilities
- Deleted components and modules
- Eliminated configuration options

#### Security
- Security improvements and enhancements
- Vulnerability fixes and patches
- Access control changes
- Authentication and authorization updates

---

**License:** All Rights Reserved - See [LICENSE](./LICENSE) file for details.

**Author:** Matt S  
**Repository:** Linux_Setup (Private)

---

**Note:** This changelog documents the evolution of the Linux server setup automation system.
