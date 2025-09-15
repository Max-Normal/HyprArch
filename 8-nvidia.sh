#  _   _       _     _ _        
# | \ | |_   _(_) __| (_) __ _  
# |  \| \ \ / / |/ _` | |/ _` | 
# | |\  |\ V /| | (_| | | (_| | 
# |_| \_| \_/ |_|\__,_|_|\__,_| 
#                               
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

echo ""
echo "-> Install main packages"

packagesPacman=(
  "nvidia-dkms"
  "nvidia-settings"
  "nvidia-utils"
)

# ------------------------------------------------------
# Install required packages
# ------------------------------------------------------
_installPackagesPacman "${packagesPacman[@]}";
_installPackagesYay "${packagesYay[@]}";


# Check if the Nvidia modules are already added in mkinitcpio.conf and add if not
if grep -qE '^MODULES=.*nvidia. *nvidia_modeset.*nvidia_uvm.*nvidia_drm' /etc/mkinitcpio.conf; then
  echo "Nvidia modules already included in /etc/mkinitcpio.conf" 2>&1
else
  sudo sed -Ei 's/^(MODULES=\([^\)]*)\)/\1 nvidia nvidia_modeset nvidia_uvm nvidia_drm)/' /etc/mkinitcpio.conf 2>&1 | tee -a "$LOG"
  echo "Nvidia modules added in /etc/mkinitcpio.conf"
fi

sudo mkinitcpio -P 
printf "\n"
printf "\n"
printf "\n"

# Additional Nvidia steps
NVEA="/etc/modprobe.d/nvidia.conf"
if [ -f "$NVEA" ]; then
  printf "${OK} Seems like nvidia-drm modeset=1 is already added in your system..moving on.\n"
  printf "\n"
else
  printf "\n"
  printf "${YELLOW} Adding options to $NVEA..."
  sudo echo -e "options nvidia-drm modeset=1" | sudo tee -a /etc/modprobe.d/nvidia.conf 2>&1
  printf "\n"
fi

# additional for GRUB users
# Check if /etc/default/grub exists
if [ -f /etc/default/grub ]; then
    # Check if nvidia_drm.modeset=1 is already present
    if ! sudo grep -q "nvidia_drm.modeset=1" /etc/default/grub; then
        # Add nvidia_drm.modeset=1 to GRUB_CMDLINE_LINUX_DEFAULT
        sudo sed -i 's/\(GRUB_CMDLINE_LINUX_DEFAULT=".*\)"/\1 nvidia_drm.modeset=1"/' /etc/default/grub
        # Regenerate GRUB configuration
        sudo grub-mkconfig -o /boot/grub/grub.cfg
        echo "nvidia_drm.modeset=1 added to /etc/default/grub"
    else
        echo "nvidia_drm.modeset=1 is already present in /etc/default/grub"
    fi
else
    echo "/etc/default/grub does not exist"
fi

# Blacklist nouveau
read -n1 -rep "${CAT} Would you like to blacklist nouveau? (y/n)" response
echo
if [[ $response =~ ^[Yy]$ ]]; then
  NOUVEAU="/etc/modprobe.d/nouveau.conf"
  if [ -f "$NOUVEAU" ]; then
    printf "${OK} Seems like nouveau is already blacklisted..moving on.\n"
  else
    printf "\n"
    echo "blacklist nouveau" | sudo tee -a "$NOUVEAU" 2>&1 | tee -a "$LOG"
    printf "${NOTE} has been added to $NOUVEAU.\n"
    printf "\n"

    # To completely blacklist nouveau (See wiki.archlinux.org/title/Kernel_module#Blacklisting 6.1)
    if [ -f "/etc/modprobe.d/blacklist.conf" ]; then
      echo "install nouveau /bin/true" | sudo tee -a "/etc/modprobe.d/blacklist.conf" 2>&1 | tee -a "$LOG"
    else
      echo "install nouveau /bin/true" | sudo tee "/etc/modprobe.d/blacklist.conf" 2>&1 | tee -a "$LOG"
    fi
  fi
else
  printf "${NOTE} Skipping nouveau blacklisting.\n"
fi

clear