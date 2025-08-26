#!/bin/bash

# if not root, run as root
if (( $EUID != 0 )); then
  sudo setup.sh
  exit
fi

function pause_script {
  read -sn 1 -p "Press any key to continue..."
}

function user_management {
  passwd root
}

function reset_repo {
  rm -rf /etc/apt/sources.list
  rm -rf /etc/apt/sources.list.d/*
  echo "## Default Kali Repositories ##" >> /etc/apt/sources.list
  echo "deb http://http.kali.org/kali kali-rolling main non-free contrib" >> /etc/apt/sources.list
  echo "# deb-src http://http.kali.org/kali kali-rolling main non-free contrib" >> /etc/apt/sources.list
}

function system_update {
  # Clear Screen
  clear

  # Update System
  apt update
  apt full-upgrade -y
  apt install -y -f
  apt autoremove -y

  # Pause
  pause_script
}

function kali_install_all {
  # Clear Screen
  clear

  # Kali Linus - All Packages
  apt install -y kali-linux-all

  # Update System
  apt update
  apt full-upgrade -y
  apt install -y -f
  apt autoremove -y

  # Pause
  pause_script
}

function backup_tools {
  rm -f /tmp/timeshift.deb
  wget -O /tmp/timeshift.deb https://github.com/teejee2008/timeshift/releases/download/v19.08.1/timeshift_19.08.1_amd64.deb
  dpkg -i /tmp/timeshift.deb
  apt install -y -f
  rm -f /tmp/timeshift.deb
}

function base_setup {
  # Clear Screen
  clear

  # Atom
  rm -f /tmp/atom.deb
  wget -O /tmp/atom.deb https://atom.io/download/deb
  dpkg -i /tmp/atom.deb
  apt install -y -f
  rm -f /tmp/atom.deb

  # Gestures
  apt install -y python3 python3-setuptools xdotool python3-gi libinput-tools python-gobject
  rm -rf /opt/gestures
  git clone https://gitlab.com/cunidev/gestures /opt/gestures
  ( cd /opt/gestures && python3 setup.py install )

  # Git
  apt install -y git-core

  # GitMiner
  apt install -y python-requests python-lxml
  rm -rf /opt/GitMiner/
  git clone https://github.com/UnkL4b/GitMiner.git /opt/GitMiner

  # Go
  rm -f /tmp/go.tar.gz
  wget -O /tmp/go.tar.gz https://dl.google.com/go/go1.11.linux-amd64.tar.gz
  tar -C /usr/local -xzf /tmp/go.tar.gz
  export PATH=$PATH:/usr/local/go/bin
  rm -f /tmp/go.tar.gz

  # Remmina
  apt install -y remmina remmina-plugin-*

  # Solaar
  apt install -y solaar solaar-*

  # Terminator
  apt install -y terminator

  # Whatportis
  pip install whatportis

  # Pause
  pause_script
}

function audio-video {
  # Clear Screen
  clear

  # ALSA
  apt install -y alsa-utils

  # VideoLAN
  apt install -y vlc

  # Pause
  pause_script
}

function network_diagnostic {
  # Clear Screen
  clear

  # bmon
  apt install -y bmon

  # gping
  pip install pinggraph

  # ipcalc
  apt install -y ipcalc

  # mtr
  apt install -y mtr

  # NetHogs
  apt install -y nethogs

  # ngrep
  apt install -y ngrep

  # sipcalc
  apt install -y sipcalc

  # Vaping
  pip install vaping

  # vnStat
  apt install -y vnstat

  # Pause
  pause_script
}

function package_manager {
  # Clear Screen
  clear

  # Synaptic
  apt install -y synaptic

  # Pause
  pause_script
}

function system_monitor {
  # Clear Screen
  clear

  # Dstat
  apt install -y dstat

  # htop
  apt install -y htop strace

  # nmon
  apt install -y nmon

  # Pause
  pause_script
}

function system_utilitie {
  # Clear Screen
  clear

  # x86 Architecture
  dpkg --add-architecture i386
  apt update

  # ccat
  go get -u github.com/jingweno/ccat
  alias cat=ccat

  # Pause
  pause_script
}

function vm_manager {
  # Clear Screen
  clear

  # VirtualBox
  vb_version=$( curl https://download.virtualbox.org/virtualbox/LATEST-STABLE.TXT)
  apt update
  apt install -y virtualbox dkms
  wget https://download.virtualbox.org/virtualbox/$vb_version/Oracle_VM_VirtualBox_Extension_Pack-$vb_version.vbox-extpack

  # Pause
  pause_script
}

function hack-tool_exploit {
  # Clear Screen
  clear

  # linux-exploit-suggester
  rm -rf /opt/linux-exploit-suggester/
  git clone https://github.com/mzet-/linux-exploit-suggester.git /opt/linux-exploit-suggester/

  # Pompem
  rm -rf /opt/Pompem/
  git clone https://github.com/rfunix/Pompem.git /opt/Pompem/
  ( cd /opt/Pompem/ && pip install -r requirements.txt )

  # Pwntools
  apt install -y python-pip python-dev git libssl-dev libffi-dev build-essential
  pip install --upgrade pip
  pip install --upgrade pwntools

  # TheFatRat
  rm -rf /opt/TheFatRat/
  git clone https://github.com/Screetsec/TheFatRat.git /opt/TheFatRat/
  ( cd /opt/TheFatRat/ && chmod +x setup.sh && ./setup.sh )

  # USB Rubber Ducky
  rm -rf /opt/USB-Rubber-Ducky/
  git clone https://github.com/hak5darren/USB-Rubber-Ducky.git /opt/USB-Rubber-Ducky/

  # Veil – Framework
  apt install -y veil

  # Windows-Exploit-Suggester
  rm -rf /opt/Windows-Exploit-Suggester/
  git clone https://github.com/GDSSecurity/Windows-Exploit-Suggester.git /opt/Windows-Exploit-Suggester/

  # ZCR-Shellcoder
  rm -rf /opt/OWASP_ZSC/
  git clone https://github.com/viraintel/OWASP-ZSC.git /opt/OWASP_ZSC/
  ( cd /opt/OWASP_ZSC/ && python installer.py )
  rm -rf /opt/OWASP_ZSC/

  # Pause
  pause_script
}

function hack-tool_post-exploit {
  # Clear Screen
  clear

  # CrackMapExec
  apt install -y crackmapexec

  # DAws
  rm -rf /opt/DAws/
  git clone https://github.com/dotcppfile/DAws.git /opt/DAws/

  # Empire
  rm -rf /opt/Empire/
  git clone https://github.com/EmpireProject/Empire.git /opt/Empire/
  ( cd /opt/Empire && chmod +x setup/install.sh && setup/install.sh )

  # Pause
  pause_script
}

function hack-tool_recon {
  # Clear Screen
  clear

  #User input
  echo "Create an account at virustotal.com, Then get your API key. You will need to enter this later."
  pause_script
  echo "Create an account at vulners.com, Then get your API key. You will need to enter this later."
  pause_script

  # DataSploit
  rm -rf /opt/DataSploit/
  git clone https://github.com/DataSploit/datasploit.git /opt/DataSploit/
  ( cd /opt/DataSploit/ && pip install --upgrade --force-reinstall -r requirements.txt )

  # EyeWitness
  rm -rf /opt/EyeWitness/
  git clone https://github.com/ChrisTruncer/EyeWitness.git /opt/EyeWitness/
  ( cd /opt/EyeWitness/ && chmod +x setup/setup.sh && setup/setup.sh )

  # Knock Subdomain Scan
  apt install -y python-dnspython
  rm -rf /opt/Knock/
  git clone https://github.com/guelfoweb/knock.git /opt/Knock/
  ( cd /opt/Knock/knockpy/ && python setup.py install )
  echo  "Get ready to enter your virustotal API key."
  pause_script
  nano /opt/Knock/knockpy/config.json

  # OSINT-Framework
  apt install -y npm
  rm -rf /opt/OSINT-Framework/
  git clone https://github.com/lockfale/OSINT-Framework.git /opt/OSINT-Framework/
  ( cd /opt/OSINT-Framework/ && npm install )
  echo "python -mwebbrowser http://localhost:8000" >> /opt/OSINT-Framework/start.sh
  echo "( cd /opt/OSINT-Framework/ && npm start )" >> /opt/OSINT-Framework/start.sh
  chmod +x /opt/OSINT-Framework/start.sh

  # OSINT-SPY
  rm -rf /opt/OSINT-SPY/
  git clone https://github.com/SharadKumar97/OSINT-SPY.git /opt/OSINT-SPY/
  ( cd /opt/OSINT-SPY/ && python install_linux.py )

  # SecLists
  rm -rf /opt/SecLists/
  git clone https://github.com/danielmiessler/SecLists.git /opt/SecLists/

  # Vulners Audit Scanner
  wget -O- https://repo.vulners.com/pubkey.txt | apt-key add -
  echo "deb http://repo.vulners.com/debian jessie main" >> /etc/apt/sources.list.d/vulners.list
  apt update && apt install vulners.agent
  echo  "Get ready to enter your Vulners API key."
  pause_script
  nano /opt/vulners/conf/vulners.conf

  # Pause
  pause_script
}

function hack-tool_training {
  # Clear Screen
  clear

  # Blue Team Training Toolkit
  rm -f /tmp/BT3.tar.gz
  rm -rf /opt/BT3-2.5/
  wget -O /tmp/BT3.tar.gz https://www.encripto.no/tools/BT3-2.8.tar.gz
  tar -zxvf /tmp/BT3.tar.gz -C /opt/
  ( cd /opt/BT3-*/ && chmod +x install.sh && ./install.sh )
  rm -f /tmp/BT3.tar.gz

  # Offensive Web Testing Framework
  pip install git+https://github.com/owtf/owtf#egg=owtf

  # Pause
  pause_script
}

function hack-tool_wireless {
  # Clear Screen
  clear

  # BetterCAP
  apt install -y bettercap

  # Blucat
  apt install -y bluez-tools libbluetooth-dev

  # Fluxion
  rm -rf /opt/fluxion/
  git clone https://github.com/FluxionNetwork/fluxion.git /opt/fluxion/
  chmod +x /opt/fluxion/fluxion.sh
  echo "(cd /opt/fluxion/ && ./fluxion.sh )" >> /opt/fluxion/start.sh
  chmod +x /opt/fluxion/start.sh

  # Pause
  pause_script
}

function hack-tool_paid_tool {
  # Clear Screen
  clear

  # Exploit Pack
  rm -rf /opt/exploitpack/
  git clone https://github.com/juansacco/exploitpack.git /opt/exploitpack/
  echo "( cd /opt/exploitpack/ && java -jar ExploitPack.jar )" >> /opt/exploitpack/start.sh
  chmod +x /opt/exploitpack/start.sh

  # Shellter
  apt install -y shellter

  # Pause
  pause_script
}

function manu_main {
  clear
  COLUMNS=$(tput cols)
  title1="################################################################################"
  title2="Configure Kali Linux, My Way! (CKLMW)"
  title3="Inital Setup & Install Script"
  title4="For Kali Linux:"
  title5="2018.3"
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
  printf "\e[96m"
  printf "%*s\n" $(((${#title2}+$COLUMNS)/2)) "$title2"
  printf "%*s\n" $(((${#title3}+$COLUMNS)/2)) "$title3"
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
  printf "\e[91m"
  printf "\n"
  printf "%*s\n" $(((${#title4}+${#title5}+$COLUMNS)/2)) "$title4 $title5"
  printf "\n"
  printf "\e[92m"
  printf "%*s\n" $(((${#title1}+$COLUMNS)/2)) "$title1"
  printf "\n"
  printf "\e[0m"
  select menusel in "User Management" "Reset sources to default" "Update the System" "Install all Metapackages" "Install Backup Tools" "Run Base Setup" "Install Audio & Video Tools" "Install Network Diagnostic Tools" "Install Package Manager" "Install System Monitor Tools" "Install System Utilities" "Install VM Manager" "Hacking Toolkits - Exploits" "Hacking Toolkits - Post-Exploits" "Hacking Toolkits - Recon" "Hacking Toolkits - Training" "Hacking Toolkits - Wireless" "Hacking Toolkits - Paid Tools" "Install All Tools & Software" "EXIT" ; do
  	case $menusel in
      "User Management")
      user_management
      clear ;;
      "Reset sources to default")
      reset_repo
      clear ;;
      "Update the System")
      system_update
      clear ;;
      "Install all Metapackages")
      kali_install_all
      clear ;;
      "Install Backup Tools")
      backup_tools
      clear ;;
      "Run Base Setup")
      base_setup
      clear ;;
      "Install Audio & Video Tools")
      audio-video
      clear ;;
      "Install Network Diagnostic Tools")
      network_diagnostic
      clear ;;
      "Install Package Manager")
      package_manager
      clear ;;
      "Install System Monitor Tools")
      system_monitor
      clear ;;
      "Install System Utilities")
      system_utilitie
      clear ;;
      "Install VM Manager")
      vm_manager
      clear ;;
      "Hacking Toolkits - Exploits")
      hack-tool_exploit
      clear ;;
      "Hacking Toolkits - Post-Exploits")
      hack-tool_post-exploit
      clear ;;
      "Hacking Toolkits - Recon")
      hack-tool_recon
      clear ;;
      "Hacking Toolkits - Training")
      hack-tool_training
      clear ;;
      "Hacking Toolkits - Wireless")
      hack-tool_wireless
      clear ;;
      "Hacking Toolkits - Paid Tools")
      hack-tool_paid_tool
      clear ;;
      "Install All Tools & Software")
      kali_install_all
      base_setup
      backup_tools
      audio-video
      network_diagnostic
      package_manager
      system_monitor
      system_utilitie
      vm_manager
      hack-tool_exploit
      hack-tool_post-exploit
      hack-tool_recon
      hack-tool_wireless
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
