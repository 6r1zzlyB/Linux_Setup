# Intel Graphics Drivers
pacman -S intel-dri
pacman -S lib32-intel-dri
pacman -S lib32-mesa
pacman -S libva
pacman -S libva-intel-driver
pacman -S mesa
pacman -S xf86-video-intel

# X Window System (Wayland)
sudo pacman -S weston
sudo pacman -S xorg-server-xwayland

# X Window System (xorg)
sudo pacman -S xorg
sudo pacman -S xorg-server

# Desktop Environment (Gnome)
sudo pacman -S gnome
sudo pacman -S gnome-extra
sudo pacman -S network-manager-applet
sudo systemctl enable gdm.service
sudo systemctl start gdm.service

# Desktop Environment (Cinnamon)
sudo pacman -S cinnamon
sudo pacman -S nemo-fileroller
sudo pacman -S gdm
sudo systemctl enable gdm.service
sudo systemctl start gdm.service