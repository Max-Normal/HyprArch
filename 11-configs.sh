#!/bin/bash
#      _       _    __ _ _           
#   __| | ___ | |_ / _(_) | ___  ___ 
#  / _` |/ _ \| __| |_| | |/ _ \/ __|
# | (_| | (_) | |_|  _| | |  __/\__ \
#  \__,_|\___/ \__|_| |_|_|\___||___/
#                                    
# by Zachary Albertyn (2023)
# ------------------------------------------------------
# Install Script for dotfiles and configuration
# yay must be installed
# ------------------------------------------------------

# ------------------------------------------------------
# Load Library
# ------------------------------------------------------
source $(dirname "$0")/scripts/library.sh
clear
echo "     _       _    __ _ _            "
echo "  __| | ___ | |_ / _(_) | ___  ___  "
echo " / _' |/ _ \| __| |_| | |/ _ \/ __| "
echo "| (_| | (_) | |_|  _| | |  __/\__ \ "
echo " \__,_|\___/ \__|_| |_|_|\___||___/ "
echo "                                    "
echo "by Zachary Albertyn (2023)"
echo "-------------------------------------"
echo ""
echo "The script will ask for permission to remove existing folders and files."
echo "But you can decide to keep your local versions by answering with No (Nn)."
echo "Symbolic links will be created from ~/dotfiles into your home and .config directories."
echo ""

# ------------------------------------------------------
# Confirm Start
# ------------------------------------------------------
while true; do
    read -p "DO YOU WANT TO START THE INSTALLATION NOW? (Yy/Nn): " yn
    case $yn in
        [Yy]* )
            echo "Installation started."
        break;;
        [Nn]* ) 
            exit;
        break;;
        * ) echo "Please answer yes or no.";;
    esac
done

# ------------------------------------------------------
# Create .config folder
# ------------------------------------------------------
echo ""
echo "-> Check if .config folder exists"

if [ -d ~/.config ]; then
    echo ".config folder already exists."
else
    mkdir ~/.config
    echo ".config folder created."
fi

# ------------------------------------------------------
# Create symbolic links
# ------------------------------------------------------
# name symlink source target

echo ""
echo "-------------------------------------"
echo "-> Install general dotfiles"
echo "-------------------------------------"
echo ""

cp -r ~/HyprArch/configs/alacritty/ ~/.config
cp -r ~/HyprArch/configs/ranger/ ~/.config
cp -r ~/HyprArch/configs/vim/ ~/.config
cp -r ~/HyprArch/configs/nvim/ ~/.config
cp -r ~/HyprArch/configs/starship.toml ~/.config/starship.toml
cp -r ~/HyprArch/configs/rofi/ ~/.config
cp -r ~/HyprArch/configs/dunst/ ~/.config
cp -r ~/HyprArch/configs/wal/ ~/.config
cp -r ~/HyprArch/configs/neofetch/ ~/.config
echo ""
echo "-------------------------------------"
echo "-> Install GTK dotfiles"
echo "-------------------------------------"
echo ""

cp -r ~/HyprArch/.gtkrc-2.0 ~/.gtkrc-2.0
cp -r ~/HyprArch/configs/gtk-3.0/ ~/.config/
cp -r ~/HyprArch/.Xresources ~/.Xresources
cp -r ~/HyprArch/.icons/ ~/

echo "-------------------------------------"
echo "-> Install Hyprland dotfiles"
echo "-------------------------------------"
echo ""

cp -r ~/HyprArch/configs/hypr/ ~/.config
cp -r ~/HyprArch/configs/waybar/ ~/.config
cp -r ~/HyprArch/configs/swaylock/ ~/.config
cp -r ~/HyprArch/configs/wlogout/ ~/.config

echo "-------------------------------------"
echo "-> Install Scripts"
echo "-------------------------------------"
echo ""

mkdir -p ~/.local/scripts
cp -r ~/HyprArch/scripts ~/.local/scripts
sudo systemctl enable sddm

# ------------------------------------------------------
# DONE
# ------------------------------------------------------
echo "DONE! Please reboot your system!"