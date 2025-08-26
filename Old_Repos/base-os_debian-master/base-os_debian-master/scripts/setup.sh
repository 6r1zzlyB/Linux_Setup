#!/bin/bash

# if not root, run as root
if (( $EUID != 0 )); then
    sudo setup.sh
    exit
fi

function pause_script {
    read -sn 1 -p "Press any key to continue..."
}

function edit_source {
    # Edit Source list
    rm -fr /etc/apt/sources.list
    cat > /etc/apt/sources.list << 'EOF'
#-----------------------------------------------------------#
#                   OFFICIAL DEBIAN REPOS                   #
#-----------------------------------------------------------#

###### Debian Main Repos
deb http://deb.debian.org/debian/ buster main
deb-src http://deb.debian.org/debian/ buster main

deb http://security.debian.org/debian-security buster/updates main contrib
deb-src http://security.debian.org/debian-security buster/updates main contrib

###### buster-updates, previously known as 'volatile'
deb http://deb.debian.org/debian/ buster-updates main contrib
deb-src http://deb.debian.org/debian/ buster-updates main contrib
EOF
    # Pause
    pause_script
}

function install_apps {
    # Clear Screen
    clear
    echo "This will install the following apps: sudo, apt-transport-https, net-tools, zip, wget, git, curl, tree, dirmngr, htop, nmon, python-pip & netdata"
    pause_script
    # Update and install apps
    apt update
    apt install -y sudo
    apt install -y apt-transport-https
    apt install -y net-tools
    apt install -y zip
    apt install -y wget
    apt install -y git
    apt install -y curl
    apt install -y tree
    apt install -y dirmngr
    apt install -y htop
    apt install -y nmon
    apt install -y python-pip
    bash <(curl -Ss https://my-netdata.io/kickstart.sh) --stable-channel
    # Pause
    pause_script
}

function install_vmtools {
    clear
    echo "This will install the following apps: open-vm-tools"
    pause_script
    # Update and install VMware Tools
    apt update
    apt install -y open-vm-tools
    # Pause
    pause_script
}

function scripts {
    clear
    # Create and edit files
    mkdir /scripts
    # Create /scripts/system_info.sh
    cat > /scripts/system_info.sh << 'EOF'
#!/bin/bash

# Sample script written for Part 4 of the RHCE series# This script will return the following set of system information:# -Hostname information:echo -e "\e[31;43m***** HOSTNAME INFORMATION *****\e[0m"
hostnamectl
echo ""

# -File system disk space usage:echo -e "\e[31;43m***** FILE SYSTEM DISK SPACE USAGE *****\e[0m"
df -h
echo ""

# -Free and used memory in the system:echo -e "\e[31;43m ***** FREE AND USED MEMORY *****\e[0m"
free
echo ""

# -System uptime and load:echo -e "\e[31;43m***** SYSTEM UPTIME AND LOAD *****\e[0m"
uptime
echo ""

# -Logged-in users:echo -e "\e[31;43m***** CURRENTLY LOGGED-IN USERS *****\e[0m"
who
echo ""

# -Top 5 processes as far as memory usage is concernedecho -e "\e[31;43m***** TOP 5 MEMORY-CONSUMING PROCESSES *****\e[0m"
ps -eo %mem,%cpu,comm --sort=-%mem | head -n 6
echo ""echo -e "\e[1;32mDone.\e[0m"
EOF
    # Create /scripts/weekly_update.sh
    cat > /scripts/weekly_update.sh << 'EOF'
#!/bin/bash

# if not root, run as root
if (( $EUID != 0 )); then
  sudo weekly_update.sh
  exit
fi

apt update
apt -y upgrade
apt -y autoremove
apt clean
dpkg -C
EOF
    # Make files exacutable
    chmod +x /scripts/system_info.sh
    chmod +x /scripts/weekly_update.sh
    # Setup cron jobs
    cat <(crontab -l) <(echo "0 2 1 * 0 /scripts/weekly_update.sh >/dev/null 2>&1") | crontab -
    # Pause
    pause_script
}

function enable_sudo {
    clear
    # Adding path for Root user
    PATH=/bin:/usr/sbin
    # Add user to sudo group
    adduser localadmin sudo
    # Pause
    pause_script
}

function enable_color {
    clear
    # Enable color in Bash
    cat > /etc/bash.bashrc << 'EOF'
# System-wide .bashrc file for interactive bash(1) shells.

# To enable the settings / commands in this file for login shells as well,
# this file has to be sourced in /etc/profile.

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, overwrite the one in /etc/profile)
# but only if not SUDOing and have SUDO_PS1 set; then assume smart user.
if ! [ -n "${SUDO_USER}" -a -n "${SUDO_PS1}" ]; then
  PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi

# Commented out, don't overwrite xterm -T "title" -n "icontitle" by default.
# If this is an xterm set the title to user@host:dir
#case "$TERM" in
#xterm*|rxvt*)
#    PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD}\007"'
#    ;;
#*)
#    ;;
#esac

# enable bash completion in interactive shells
#if ! shopt -oq posix; then
#  if [ -f /usr/share/bash-completion/bash_completion ]; then
#    . /usr/share/bash-completion/bash_completion
#  elif [ -f /etc/bash_completion ]; then
#    . /etc/bash_completion
#  fi
#fi

# if the command-not-found package is installed, use it
if [ -x /usr/lib/command-not-found -o -x /usr/share/command-not-found/command-not-found ]; then
        function command_not_found_handle {
                # check because c-n-f could've been removed in the meantime
                if [ -x /usr/lib/command-not-found ]; then
                   /usr/lib/command-not-found -- "$1"
                   return $?
                elif [ -x /usr/share/command-not-found/command-not-found ]; then
                   /usr/share/command-not-found/command-not-found -- "$1"
                   return $?
                else
                   printf "%s: command not found\n" "$1" >&2
                   return 127
                fi
        }
fi

export LS_OPTIONS='--color=auto'
eval "`dircolors`"
alias ls='ls $LS_OPTIONS'
EOF
    # Pause
    pause_script
}

function update_reboot {
    clear
    # Clean unmet dependencies
    apt autoclean
    apt autoremove
    apt install -f
    dpkg --configure -a
    # Reboot server
    reboot now
}

function manu_main {
    clear
    COLUMNS=$(tput cols)
    title1="################################################################################"
    Name="Computer Name: "$(uname -n)
    OS="Operating System: "$(uname -o)
    Architecture="Architecture Type: "$(uname -m)
    Kernel="Kernel Version: "$(uname -r)
    IP_Interface="Network Interface: "$(ip route show | awk '(NR == 2) {print $3}')
    IP_Address="IP Address: "$(ip route show | awk '(NR == 2) {print $9}')
    IP_Route="Default Route: "$(ip route show default | awk '/default/ {print $3}')
    printf "\n"
    printf "\e[92m"
    printf "%*s\n" $(((${#title1}+$COLUMNS)/2)) "$title1"
    printf "\n"
    printf "\e[93m"
    printf "%*s\n" $(((${#Name}+$COLUMNS)/2)) "$Name"
    printf "%*s\n" $(((${#OS}+$COLUMNS)/2)) "$OS"
    printf "%*s\n" $(((${#Architecture}+$COLUMNS)/2)) "$Architecture"
    printf "%*s\n" $(((${#Kernel}+$COLUMNS)/2)) "$Kernel"
    printf "\n"
    printf "\e[95m"
    printf "%*s\n" $(((${#IP_Interface}+$COLUMNS)/2)) "$IP_Interface"
    printf "%*s\n" $(((${#IP_Address}+$COLUMNS)/2)) "$IP_Address"
    printf "%*s\n" $(((${#IP_Route}+$COLUMNS)/2)) "$IP_Route"
    printf "\n"
    printf "\e[92m"
    printf "%*s\n" $(((${#title1}+$COLUMNS)/2)) "$title1"
    printf "\n"
    printf "\e[0m"
    select menusel in "Edit Source file" "Install Apps" "Install VMware Tools" "Build Maint Scripts" "Enable sudo for localadmin" "Enable color for terminal" "Update & Reboot" "EXIT" ; do
        case $menusel in
            "Edit Source file")
                edit_source
                clear ;;
            "Install Apps")
                install_apps
                clear ;;
            "Install VMware Tools")
                install_vmtools
                clear ;;
            "Build Maint Scripts")
                scripts
                clear ;;
            "Enable sudo for localadmin")
                enable_sudo
                clear ;;
            "Enable color for terminal")
                enable_color
                clear ;;
            "Update & Reboot")
                update_reboot
                clear ;;
            "EXIT")
                clear && exit 0 ;;
            * )
                screwup
                clear ;;
        esac
        break
    done
}

while true; do manu_main; done
