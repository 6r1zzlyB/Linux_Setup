#!/bin/bash

# =============================================================================
# Linux Server First Run Setup Script
# For Debian/Ubuntu based systems
# =============================================================================

set -euo pipefail  # Exit on error, undefined vars, pipe failures

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Configuration variables
INSTALL_COCKPIT=${INSTALL_COCKPIT:-false}
SETUP_NFS_MOUNT=${SETUP_NFS_MOUNT:-false}
NFS_SERVER=${NFS_SERVER:-"192.168.1.10"}
NFS_PATH=${NFS_PATH:-"/volume1/SNAS"}
NFS_MOUNT_POINT=${NFS_MOUNT_POINT:-"/nas"}
INSTALL_OH_MY_ZSH=${INSTALL_OH_MY_ZSH:-true}
SETUP_SUDO_USER=${SETUP_SUDO_USER:-""}
CREATE_USER=${CREATE_USER:-""}
INSTALL_VM_TOOLS=${INSTALL_VM_TOOLS:-false}

# Logging function
log() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
}

warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

# Check if running as root
check_root() {
    if [[ $EUID -ne 0 ]]; then
        error "This script must be run as root"
        exit 1
    fi
}

# Fix PATH environment for root user
fix_root_path() {
    log "Configuring PATH environment for root user..."
    
    # Set PATH for current session
    export PATH="/usr/local/sbin:/usr/sbin:/sbin:/usr/local/bin:/usr/bin:/bin:$PATH"
    
    # Check if PATH is already configured in .bashrc
    if ! grep -q 'export PATH="/usr/local/sbin:/usr/sbin:/sbin:/usr/local/bin:/usr/bin:/bin"' /root/.bashrc 2>/dev/null; then
        info "Adding PATH configuration to /root/.bashrc..."
        echo 'export PATH="/usr/local/sbin:/usr/sbin:/sbin:/usr/local/bin:/usr/bin:/bin:$PATH"' >> /root/.bashrc
        log "PATH configuration added to root's .bashrc"
    else
        info "PATH already configured in /root/.bashrc"
    fi
    
    # Also add to .profile for login shells
    if ! grep -q 'export PATH="/usr/local/sbin:/usr/sbin:/sbin:/usr/local/bin:/usr/bin:/bin"' /root/.profile 2>/dev/null; then
        info "Adding PATH configuration to /root/.profile..."
        echo 'export PATH="/usr/local/sbin:/usr/sbin:/sbin:/usr/local/bin:/usr/bin:/bin:$PATH"' >> /root/.profile
    fi
    
    log "Root PATH environment configured successfully"
}

# Detect OS version
detect_os() {
    if [[ -f /etc/os-release ]]; then
        . /etc/os-release
        OS=$NAME
        VERSION=$VERSION_ID
        CODENAME=$VERSION_CODENAME
        log "Detected OS: $OS $VERSION ($CODENAME)"
    else
        error "Cannot detect OS version"
        exit 1
    fi
}

# Update system packages
update_system() {
    log "Updating system packages..."
    apt update
    apt upgrade -y
    log "System packages updated successfully"
}

# Install essential packages
install_essential_packages() {
    log "Installing essential packages..."
    
    local packages=(
        "sudo"  # Install sudo first since it's not default on Debian
        "apt-listchanges"
        "apt-transport-https"
        "curl"
        "figlet"
        "git"
        "htop"
        "lolcat"
        "nano"
        "tree"
        "wget"
        "zip"
        "iputils-ping"
        "net-tools"
        "dnsutils"
        "ipcalc"
        "apt-show-versions"
        "screen"
        "zsh"
        "unattended-upgrades"
        "apt-config-auto-update"
        "landscape-common"
        "bc"  # Added for MOTD calculations
    )
    
    # Add open-vm-tools if requested
    if [[ "$INSTALL_VM_TOOLS" == "true" ]]; then
        info "Adding open-vm-tools to installation list..."
        packages+=("open-vm-tools")
    else
        warning "Skipping open-vm-tools installation (use --install-vm-tools for VMware environments)"
    fi
    
    for package in "${packages[@]}"; do
        info "Installing $package..."
        apt install -y "$package"
    done
    
    log "Essential packages installed successfully"
}

# Configure unattended upgrades
configure_unattended_upgrades() {
    log "Configuring unattended upgrades..."
    dpkg-reconfigure --priority=low unattended-upgrades
    log "Unattended upgrades configured"
}

# Setup user account and sudo access
setup_sudo_user() {
    # Create new user if specified
    if [[ -n "$CREATE_USER" ]]; then
        log "Creating new user: $CREATE_USER"
        
        if id "$CREATE_USER" &>/dev/null; then
            warning "User $CREATE_USER already exists"
        else
            info "Creating user $CREATE_USER..."
            useradd -m -s /bin/bash "$CREATE_USER"
            
            # Set password interactively
            echo "Please set password for user $CREATE_USER:"
            passwd "$CREATE_USER"
            
            # Set this as the sudo user to configure
            SETUP_SUDO_USER="$CREATE_USER"
            info "User $CREATE_USER created successfully"
        fi
    fi
    
    # Configure sudo access for specified user
    if [[ -n "$SETUP_SUDO_USER" ]]; then
        log "Configuring sudo access for user: $SETUP_SUDO_USER"
        
        # Check if user exists
        if ! id "$SETUP_SUDO_USER" &>/dev/null; then
            error "User $SETUP_SUDO_USER does not exist. Cannot configure sudo access."
            return 1
        fi
        
        # Add user to sudo group
        info "Adding $SETUP_SUDO_USER to sudo group..."
        usermod -aG sudo "$SETUP_SUDO_USER"
        
        # Optional: Add user to sudoers file for passwordless sudo (commented out for security)
        # echo "$SETUP_SUDO_USER ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/$SETUP_SUDO_USER
        
        log "Sudo access configured for $SETUP_SUDO_USER"
        info "User $SETUP_SUDO_USER can now use sudo commands"
    else
        warning "No user specified for sudo configuration"
    fi
}

# Install Oh My Zsh for root and current user
install_oh_my_zsh() {
    if [[ "$INSTALL_OH_MY_ZSH" == "true" ]]; then
        log "Installing Oh My Zsh..."
        
        # Install for root
        info "Installing Oh My Zsh for root user..."
        RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" || true
        
        # Install for specified sudo user
        if [[ -n "$SETUP_SUDO_USER" ]] && id "$SETUP_SUDO_USER" &>/dev/null; then
            info "Installing Oh My Zsh for user: $SETUP_SUDO_USER..."
            sudo -u "$SETUP_SUDO_USER" RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" || true
        elif [[ -n "${SUDO_USER:-}" ]]; then
            # Fallback to original SUDO_USER if no specific user set
            info "Installing Oh My Zsh for user: $SUDO_USER..."
            sudo -u "$SUDO_USER" RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" || true
        fi
        
        log "Oh My Zsh installation completed"
    else
        warning "Skipping Oh My Zsh installation"
    fi
}

# Setup custom MOTD
setup_motd() {
    log "Setting up custom MOTD..."
    
    # Disable default MOTD services
    info "Disabling default MOTD services..."
    systemctl disable motd-news.service 2>/dev/null || true
    systemctl disable motd-news.timer 2>/dev/null || true
    
    # Remove existing MOTD files
    info "Cleaning existing MOTD files..."
    rm -f /etc/update-motd.d/*
    
    # Create custom MOTD script
    info "Creating custom MOTD script..."
    cat > /etc/update-motd.d/00-motd << 'EOF'
#!/bin/bash

# Set colors
R="\e[0;31m"        # Red
G="\e[0;32m"        # Green
B="\e[0;34m"        # Blue
C="\e[0;36m"        # Cyan
W="\e[0;39m"        # Default
BR="\e[1;31m"       # Bold Red
BG="\e[1;32m"       # Bold Green
BB="\e[1;34m"       # Bold Blue
BC="\e[1;36m"       # Bold Cyan
CN="${CN:-\e[0m}"   # None
CE="${CE:-\e[31m}"  # Error
CO="${CO:-\e[32m}"  # Ok
CW="${CW:-\e[33m}"  # Warning
CA="${CA:-\e[34m}"  # Accent

# get load averages
IFS=" " read LOAD1 LOAD5 LOAD15 <<<$(cat /proc/loadavg | awk '{ print $1,$2,$3 }')
# get free memory
IFS=" " read USED AVAIL TOTAL <<<$(free -htm | grep "Mem" | awk {'print $3,$7,$2'})
# get processes
PROCESS=`ps -eo user=|sort|uniq -c | awk '{ print $2 " " $1 }'`
PROCESS_ALL=`echo "$PROCESS"| awk {'print $2'} | awk '{ SUM += $1} END { print SUM }'`
PROCESS_ROOT=`echo "$PROCESS"| grep root | awk {'print $2'}`
PROCESS_USER=`echo "$PROCESS"| grep -v root | awk {'print $2'} | awk '{ SUM += $1} END { print SUM }'`
# get processors
PROCESSOR_NAME=`grep "model name" /proc/cpuinfo | cut -d ' ' -f3- | awk {'print $0'} | head -1`
PROCESSOR_COUNT=`grep -ioP 'processor\t:' /proc/cpuinfo | wc -l`
# get ip address
NET=`hostname -I | /usr/bin/cut -d " " -f 1`

# Print System Info
echo -e "
$W  Hostname....: $BR$(hostname)
$W  IP..........: $BG$NET

$BC  SYSTEM INFO:
$W  Distro......: $BG`cat /etc/*release | grep "PRETTY_NAME" | cut -d "=" -f 2- | sed 's/"//g'`
$W  Kernel......: $BG`uname -sr`
$W  Uptime......: $W`uptime -p`

$W  Load........: $BG$LOAD1$W (1m), $BG$LOAD5$W (5m), $BG$LOAD15$W (15m)
$W  Processes...: $BG$PROCESS_ROOT$W (root), $BG$PROCESS_USER$W (user), $BG$PROCESS_ALL$W (total)
$W  CPU.........: $W$PROCESSOR_NAME ($BG$PROCESSOR_COUNT$W vCPU)
$W  Memory......: $BG$USED$W used, $BG$AVAIL$W avail, $BG$TOTAL$W total$W"

# Print color function
print_color() {
    local out=""
    if (( $(bc -l <<< "$2 < $3") )); then
        out+="${CO}"
    elif (( $(bc -l <<< "$2 >= $3 && $2 < $4") )); then
        out+="${CW}"
    else
        out+="${CE}"
    fi
    out+="$1${CN}"
    echo "$out"
}

print_columns() {
    [ -z "$2" ] && return
    echo -e ""
    paste <(echo -e "${CA}$1${1:+:}${CN}") <(echo -e "$2")
}

# Check for available updates
if type apt >/dev/null 2>&1; then
    updates=$(apt list --upgradable 2>/dev/null | grep upgradable | wc -l)
else
    updates="N/A"
fi

text="$(print_color "$updates available" $updates 1 50)"
print_columns "$BB  UPDATES AVAILABLE" "$text"
echo -e ""
EOF

    # Make MOTD script executable
    chmod 755 /etc/update-motd.d/00-motd
    
    log "Custom MOTD setup completed"
}

# Install Cockpit (optional)
install_cockpit() {
    if [[ "$INSTALL_COCKPIT" == "true" ]]; then
        log "Installing Cockpit..."
        
        info "Installing Cockpit from backports..."
        apt install -t "${CODENAME}-backports" cockpit -y
        apt install cockpit-pcp -y
        
        info "Installing Cockpit Navigator..."
        local navigator_url="https://github.com/45Drives/cockpit-navigator/releases/download/v0.5.10/cockpit-navigator_0.5.10-1focal_all.deb"
        local navigator_deb="/tmp/cockpit-navigator.deb"
        
        wget -O "$navigator_deb" "$navigator_url"
        apt install "$navigator_deb" -y
        rm -f "$navigator_deb"
        
        # Enable and start cockpit
        systemctl enable --now cockpit.socket
        
        log "Cockpit installed and enabled"
        info "Access Cockpit at: https://$(hostname -I | cut -d' ' -f1):9090"
    else
        warning "Skipping Cockpit installation"
    fi
}

# Setup NFS mount (optional)
setup_nfs_mount() {
    if [[ "$SETUP_NFS_MOUNT" == "true" ]]; then
        log "Setting up NFS mount..."
        
        # Install NFS client
        info "Installing NFS client..."
        apt install -y nfs-common
        
        # Create mount point
        info "Creating mount point: $NFS_MOUNT_POINT"
        mkdir -p "$NFS_MOUNT_POINT"
        
        # Add to fstab
        info "Adding NFS mount to /etc/fstab..."
        local fstab_entry="$NFS_SERVER:$NFS_PATH $NFS_MOUNT_POINT nfs rw,noatime,rsize=1048576,wsize=1048576,hard,tcp,_netdev 0 0"
        
        # Check if entry already exists
        if ! grep -q "$NFS_SERVER:$NFS_PATH" /etc/fstab; then
            echo "$fstab_entry" >> /etc/fstab
            info "NFS mount added to fstab"
        else
            warning "NFS mount already exists in fstab"
        fi
        
        # Mount the drive
        info "Mounting NFS drive..."
        mount -a
        
        # Add to root's crontab for auto-mount on boot
        info "Adding auto-mount to root crontab..."
        (crontab -l 2>/dev/null; echo "@reboot /usr/bin/mount -a") | crontab -
        
        log "NFS mount setup completed"
    else
        warning "Skipping NFS mount setup"
    fi
}

# Display completion summary
display_summary() {
    echo ""
    log "=========================================="
    log "Server setup completed successfully!"
    log "=========================================="
    echo ""
    
    info "Installed packages:"
    echo "  ✓ System updates and essential tools"
    echo "  ✓ Development tools (git, nano, etc.)"
    echo "  ✓ Network utilities"
    echo "  ✓ System monitoring tools"
    echo "  ✓ Unattended upgrades"
    echo "  ✓ sudo package (required for Debian)"
    echo "  ✓ Root PATH environment configured"
    
    if [[ -n "$CREATE_USER" ]]; then
        echo "  ✓ Created user: $CREATE_USER"
    fi
    
    if [[ -n "$SETUP_SUDO_USER" ]]; then
        echo "  ✓ Configured sudo access for: $SETUP_SUDO_USER"
    fi
    
    if [[ "$INSTALL_OH_MY_ZSH" == "true" ]]; then
        echo "  ✓ Oh My Zsh shell"
    fi
    
    if [[ "$INSTALL_VM_TOOLS" == "true" ]]; then
        echo "  ✓ open-vm-tools (VMware integration)"
    fi
    
    if [[ "$INSTALL_COCKPIT" == "true" ]]; then
        echo "  ✓ Cockpit web interface"
        info "Access Cockpit at: https://$(hostname -I | cut -d' ' -f1):9090"
    fi
    
    if [[ "$SETUP_NFS_MOUNT" == "true" ]]; then
        echo "  ✓ NFS mount configured"
    fi
    
    echo ""
    info "Custom MOTD has been configured"
    info "System is ready for use!"
    
    warning "It's recommended to reboot the system to ensure all changes take effect"
    echo ""
}

# Main execution
main() {
    log "Starting Linux server first-run setup..."
    
    check_root
    fix_root_path
    detect_os
    update_system
    install_essential_packages
    configure_unattended_upgrades
    setup_sudo_user
    install_oh_my_zsh
    setup_motd
    install_cockpit
    setup_nfs_mount
    display_summary
}

# Handle script arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --install-cockpit)
            INSTALL_COCKPIT=true
            shift
            ;;
        --setup-nfs)
            SETUP_NFS_MOUNT=true
            shift
            ;;
        --nfs-server)
            NFS_SERVER="$2"
            shift 2
            ;;
        --nfs-path)
            NFS_PATH="$2"
            shift 2
            ;;
        --nfs-mount-point)
            NFS_MOUNT_POINT="$2"
            shift 2
            ;;
        --skip-zsh)
            INSTALL_OH_MY_ZSH=false
            shift
            ;;
        --create-user)
            CREATE_USER="$2"
            shift 2
            ;;
        --setup-sudo-user)
            SETUP_SUDO_USER="$2"
            shift 2
            ;;
        --install-vm-tools)
            INSTALL_VM_TOOLS=true
            shift
            ;;
        --help)
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --install-cockpit            Install Cockpit web interface"
            echo "  --setup-nfs                  Setup NFS mount"
            echo "  --nfs-server SERVER          NFS server IP (default: 192.168.1.10)"
            echo "  --nfs-path PATH              NFS path (default: /volume1/SNAS)"
            echo "  --nfs-mount-point DIR        Local mount point (default: /nas)"
            echo "  --skip-zsh                   Skip Oh My Zsh installation"
            echo "  --create-user USERNAME       Create new user account"
            echo "  --setup-sudo-user USERNAME   Configure existing user for sudo access"
            echo "  --install-vm-tools           Install open-vm-tools (for VMware environments)"
            echo "  --help                       Show this help message"
            echo ""
            echo "Environment-specific Examples:"
            echo "  # VMware/ESXi environment"
            echo "  $0 --create-user admin --install-vm-tools --install-cockpit"
            echo ""
            echo "  # XCP-ng/Citrix Hypervisor environment"
            echo "  $0 --create-user admin --install-cockpit"
            echo ""
            echo "  # Bare metal server"
            echo "  $0 --create-user admin --setup-nfs --install-cockpit"
            echo ""
            echo "User Management Examples:"
            echo "  $0 --create-user john                    # Create user 'john' and configure sudo"
            echo "  $0 --setup-sudo-user existing_user       # Add sudo access to existing user"
            echo ""
            echo "Full Setup Example:"
            echo "  $0 --create-user admin --install-cockpit --setup-nfs --install-vm-tools"
            echo ""
            echo "Note: sudo package will be installed automatically (required for Debian)"
            exit 0
            ;;
        *)
            error "Unknown option: $1"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

# Run main function
main