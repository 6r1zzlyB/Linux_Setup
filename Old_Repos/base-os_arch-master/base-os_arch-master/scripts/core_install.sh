# sudo
pacman -S sudo

# Core Apps
sudo pacman -S base
sudo pacman -S base-devel

# New User (gHost)
useradd -m -G wheel -s /bin/bash gHost
passwd gHost
sudo visudo
	# Uncomment the line below
	# %wheel ALL=(ALL) ALL

# Package Manager (yay)
sudo pacman -S git
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si