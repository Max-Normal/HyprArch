#/bin/bash
#     _                         ___           _        _ _  
#    / \   _ __  _ __  ___     |_ _|_ __  ___| |_ __ _| | | 
#   / _ \ | '_ \| '_ \/ __|_____| || '_ \/ __| __/ _` | | | 
#  / ___ \| |_) | |_) \__ \_____| || | | \__ \ || (_| | | | 
# /_/   \_\ .__/| .__/|___/    |___|_| |_|___/\__\__,_|_|_| 
#         |_|   |_|                                         
#  
# by Zachary Albertyn (2023) 
# ----------------------------------------------------- 
# Install Script for required packages
# ------------------------------------------------------

# ------------------------------------------------------
# Load Library
# ------------------------------------------------------
source $(dirname "$0")/scripts/library.sh
clear
echo "  ___           _        _ _  "
echo " |_ _|_ __  ___| |_ __ _| | | "
echo "  | ||  _ \/ __| __/ _  | | | "
echo "  | || | | \__ \ || (_| | | | "
echo " |___|_| |_|___/\__\__,_|_|_| "
echo "                              "
echo "by Zachary Albertyn (2023)"
echo "-------------------------------------"
echo ""

# ------------------------------------------------------
# Check if yay is installed
# ------------------------------------------------------
if sudo pacman -Qs yay > /dev/null ; then
    echo "yay is installed. You can proceed with the installation"
else
    echo "yay is not installed. Will be installed now!"
    git clone https://aur.archlinux.org/yay-bin.git ~/yay-bin
    cd ~/yay-bin
    makepkg -si
    cd ~/HyprArch/
    clear
    echo "yay has been installed successfully."
    echo ""
    echo "  ___           _        _ _  "
    echo " |_ _|_ __  ___| |_ __ _| | | "
    echo "  | ||  _ \/ __| __/ _  | | | "
    echo "  | || | | \__ \ || (_| | | | "
    echo " |___|_| |_|___/\__\__,_|_|_| "
    echo "                              "
    echo "by Zachary Albertyn (2023)"
    echo "-------------------------------------"
    echo ""
fi

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
# Install required packages
# ------------------------------------------------------
echo ""
echo "-> Install main packages"

packagesPacman=(
    "pacman-contrib"
    "alacritty"
    "sddm"
    "rofi" 
    "chromium" 
    "micro" 
    "dunst" 
    "starship"
    "neovim" 
    "mpv" 
    "freerdp" 
    "gnome-disk-utility" 
    "thunar"
    "thunar-volman"
    "thunar-media-tags-plugin"
    "thunar-archive-plugin"
    "mousepad" 
    "ttf-font-awesome" 
    "ttf-fira-sans" 
    "ttf-fira-code" 
    "ttf-firacode-nerd" 
    "figlet" 
    "gparted" 
    "breeze" 
    "breeze-gtk" 
    "vlc" 
    "exa" 
    "python-pip" 
    "python-psutil" 
    "python-rich" 
    "python-click" 
    "xdg-desktop-portal-gtk"
    "pavucontrol" 
    "tumbler" 
    "pass"
    "qtpass"
    "libreoffice-fresh"
    "zathura"
    "file-roller"
    "mpd"
    "ncmpcpp"
    "thunderbird"
    "gimp"
    "inkscape"
    "blender"
    "plymouth" 
    "blueman"
    "qt5-charts"
);

packagesYay=(
    "brave-bin" 
    "pfetch" 
    "bibata-cursor-theme" 
    "trizen"
    "wlsunset"
    "nwg-look"
    "freedownloadmanager"
    "spotify"
);
  
# ------------------------------------------------------
# Install required packages
# ------------------------------------------------------
_installPackagesPacman "${packagesPacman[@]}";
_installPackagesYay "${packagesYay[@]}";

# ------------------------------------------------------
# Install pywal
# ------------------------------------------------------
if [ -f /usr/bin/wal ]; then
    echo "pywal already installed."
else
    yay --noconfirm -S pywal
fi

clear

# ------------------------------------------------------
# Install .bashrc
# ------------------------------------------------------
echo ""
echo "-> Install .bashrc"

cp -r ~/HyprArch/.bashrc ~/.bashrc

# ------------------------------------------------------
# Install custom issue (login prompt)
# ------------------------------------------------------
echo ""
echo "-> Install login screen"
while true; do
    read -p "Do you want to install the custom login prompt? (Yy/Nn): " yn
    case $yn in
        [Yy]* )
            sudo cp ~/HyprArch/login/issue /etc/issue
            echo "Login prompt installed."
        break;;
        [Nn]* ) 
            echo "Custom login prompt skipped."
        break;;
        * ) echo "Please answer yes or no.";;
    esac
done

# ------------------------------------------------------
# Install wallpapers
# ------------------------------------------------------
echo ""
echo "-> Install wallpapers"
while true; do
    read -p "Do you want to copy the wallpapers? (Yy/Nn): " yn
    case $yn in
        [Yy]* )
            if [ -d ~/Pictures/Wallpapers ]; then
                echo "Wallpaper Folder already exists."
            else
                cp -r ~/HyprArch/wallpapers ~/Pictures/Wallpapers
                echo "Wallpapers installed."
            fi
            echo "Wallpapers installed."
        break;;
        [Nn]* ) 
            if [ -d ~/Pictures/Wallpapers ]; then
                echo "Wallpaper Folder already exists."
            else
                mkdir -p ~/Pictures/Wallpapers
            fi
            cp -r ~/HyprArch/default.jpg ~/Pictures/Wallpapers
            echo "Default Wallpaper installed."
        break;;
        * ) echo "Please answer yes or no.";;
    esac
done

# ------------------------------------------------------
# Init pywal
# ------------------------------------------------------
echo ""
echo "-> Init pywal"
wal -i ~/Pictures/Wallpapers/default.jpg
echo "pywal initiated."

# ------------------------------------------------------
# DONE
# ------------------------------------------------------
