# When you run the following command and get
	# Possibly missing firmware for module: aic94xx
	# Possibly missing firmware for module: wd719x
sudo mkinitcpio -p linux

# Run
git clone https://aur.archlinux.org/aic94xx-firmware.git
cd aic94xx-firmware
makepkg -sri
git clone https://aur.archlinux.org/wd719x-firmware.git
cd wd719x-firmware
makepkg -sri