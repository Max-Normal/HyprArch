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

flatpak install flathub com.github.tchx84.Flatseal

flatpak install flathub com.discordapp.Discord

git clone https://github.com/AdnanHodzic/auto-cpufreq.git
cd auto-cpufreq && sudo ./auto-cpufreq-installer

git clone --depth 1 https://gitlab.com/VandalByte/darkmatter-grub-theme.git && cd darkmatter-grub-theme
sudo python3 darkmatter-theme.py --install

sudo git clone https://github.com/keyitdev/sddm-astronaut-theme.git /usr/share/sddm/themes/sddm-astronaut-theme
sudo cp -r /usr/share/sddm/themes/sddm-astronaut-theme/Fonts/* /usr/share/fonts/
echo "[Theme]
Current=sddm-astronaut-theme" | sudo tee /etc/sddm.conf
