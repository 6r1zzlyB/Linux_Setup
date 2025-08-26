sudo pacman -Syy
sudo pacman -Syu
sudo pacman -R $(pacman -Qdtq)
sudo pacman -Rns $(pacman -Qtdq)