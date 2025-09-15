#!/bin/bash
#  _   _                  _                 _  
# | | | |_   _ _ __  _ __| | __ _ _ __   __| | 
# | |_| | | | | '_ \| '__| |/ _` | '_ \ / _` | 
# |  _  | |_| | |_) | |  | | (_| | | | | (_| | 
# |_| |_|\__, | .__/|_|  |_|\__,_|_| |_|\__,_| 
#        |___/|_|                              
#  
# by Zachary Albertyn (2023) 
# ----------------------------------------------------- 
# Install Script for Hyprland
# ------------------------------------------------------

# ------------------------------------------------------
# Confirm Start
# ------------------------------------------------------
source $(dirname "$0")/scripts/library.sh
clear
echo "  _   _                  _                 _  "
echo " | | | |_   _ _ __  _ __| | __ _ _ __   __| | "
echo " | |_| | | | | ,_ \| ,__| |/ _\ | ,_ \ / _, | "
echo " |  _  | |_| | |_) | |  | | (_| | | | | (_| | "
echo " |_| |_|\__, | .__/|_|  |_|\__,_|_| |_|\__,_| "
echo "        |___/|_|                              "
echo "                             " 
echo "by Zachary Albertyn (2023)"
echo "------------------------------------------------------"
echo ""

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
echo ""

# ------------------------------------------------------
# Install required packages
# ------------------------------------------------------
echo ""
echo "-> Install main packages"
packagesPacman=(
    "qt5-wayland"
    "qt5ct"
    "qt6-wayland"
    "libva" 
    "xdg-desktop-portal-hyprland" 
    "waybar" 
    "grim" 
    "slurp"
    "swayidle"
    "hyprland"
    "intel-media-driver"
);

packagesYay=(
    "libva-nvidia-driver-git"
    "swww" 
    "swaylock-effects" 
    "wlogout"
);

# ------------------------------------------------------
# Install required packages
# ------------------------------------------------------
_installPackagesPacman "${packagesPacman[@]}";
_installPackagesYay "${packagesYay[@]}";

echo ""
echo "DONE! Please reboot your system!"