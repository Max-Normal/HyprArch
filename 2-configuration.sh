#!/bin/bash

#   ____             __ _                       _   _              
#  / ___|___  _ __  / _(_) __ _ _   _ _ __ __ _| |_(_) ___  _ __   
# | |   / _ \| '_ \| |_| |/ _` | | | | '__/ _` | __| |/ _ \| '_ \  
# | |__| (_) | | | |  _| | (_| | |_| | | | (_| | |_| | (_) | | | | 
#  \____\___/|_| |_|_| |_|\__, |\__,_|_|  \__,_|\__|_|\___/|_| |_| 
#                         |___/                                    
#  
# by Zachary Albertyn (2023) 
# ----------------------------------------------------- 
clear
keyboardlayout="us"
zoneinfo="Africa/Johannesburg"
hostname="MSi-Laptop"
username="zachary"

# ------------------------------------------------------
# Set System Time
# ------------------------------------------------------
ln -sf /usr/share/zoneinfo/$zoneinfo /etc/localtime
hwclock --systohc

# ------------------------------------------------------
# Update reflector
# ------------------------------------------------------
echo "Start reflector..."
reflector --country ZA --sort rate --save /etc/pacman.d/mirrorlist

# ------------------------------------------------------
# Synchronize mirrors
# ------------------------------------------------------
pacman -Syy

# ------------------------------------------------------
# Install Packages
# ------------------------------------------------------
pacman --noconfirm -S grub xdg-desktop-portal-wlr networkmanager network-manager-applet dialog wpa_supplicant mtools dosfstools base-devel linux-headers avahi xdg-user-dirs xdg-utils gvfs gvfs-smb nfs-utils inetutils dnsutils bluez bluez-utils cups cups-pdf print-manager alsa-utils pipewire pipewire-audio pipewire-alsa pipewire-pulse pipewire-jack wireplumber bash-completion rsync reflector acpi acpi_call dnsmasq openbsd-netcat ipset firewalld flatpak sof-firmware nss-mdns acpid os-prober ntfs-3g terminus-font exa bat htop ranger zip unzip neofetch duf xorg-xhost xorg-xwayland grub-btrfs xf86-video-intel xf86-video-qxl brightnessctl pacman-contrib inxi tlp inotify-tools

# ------------------------------------------------------
# set lang utf8 US
# ------------------------------------------------------
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf

# ------------------------------------------------------
# Set Keyboard
# ------------------------------------------------------

echo "KEYMAP=$keyboardlayout" >> /etc/vconsole.conf

# ------------------------------------------------------
# Set hostname and localhost
# ------------------------------------------------------
echo "$hostname" >> /etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1       localhost" >> /etc/hosts
echo "127.0.1.1 $hostname.localdomain $hostname" >> /etc/hosts
clear

# ------------------------------------------------------
# Set Root Password
# ------------------------------------------------------
echo "Set root password"
passwd root

# ------------------------------------------------------
# Add User
# ------------------------------------------------------
echo "Add user $username"
useradd -m -G wheel $username
passwd $username

# ------------------------------------------------------
# Enable Services
# ------------------------------------------------------
systemctl enable NetworkManager
systemctl enable bluetooth
systemctl enable cups.service
systemctl enable tlp
systemctl mask systemd-rfkill.socket
systemctl mask systemd-rfkill.service
systemctl enable avahi-daemon
systemctl enable reflector.timer
systemctl enable fstrim.timer
systemctl enable firewalld
systemctl enable acpid

# ------------------------------------------------------
# Grub installation
# ------------------------------------------------------
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB --removable
grub-mkconfig -o /boot/grub/grub.cfg

# ------------------------------------------------------
# Add btrfs and setfont to mkinitcpio
# ------------------------------------------------------
# Before: BINARIES=()
# After:  BINARIES=(btrfs)
sed -i 's/BINARIES=()/BINARIES=(btrfs)/g' /etc/mkinitcpio.conf
mkinitcpio -p linux

# ------------------------------------------------------
# Add user to wheel
# ------------------------------------------------------
clear
echo "Uncomment %wheel group in sudoers (around line 85):"
echo "Before: #%wheel ALL=(ALL:ALL) ALL"
echo "After:  %wheel ALL=(ALL:ALL) ALL"
echo ""
read -p "Open sudoers now?" c
EDITOR=vim sudo -E visudo
usermod -aG wheel $username

# ------------------------------------------------------
# Copy installation scripts to home directory 
# ------------------------------------------------------
cp /HyprArch/3-yay.sh /home/$username
cp /HyprArch/4-snapper.sh /home/$username
cp /HyprArch/5-zram.sh /home/$username
cp /HyprArch/6-preload.sh /home/$username
cp /HyprArch/7-kvm.sh /home/$username
cp /HyprArch/8-nvidia.sh /home/$username
cp /HyprArch/9-apps.sh /home/$username
cp /HyprArch/10-hyprland.sh /home/$username
cp /HyprArch/11-configs.sh /home/$username
cp /HyprArch/12-gitflats.sh /home/$username

clear
echo "     _                   "
echo "  __| | ___  _ __   ___  "
echo " / _' |/ _ \| '_ \ / _ \ "
echo "| (_| | (_) | | | |  __/ "
echo " \__,_|\___/|_| |_|\___| "
echo "                         "
echo ""
echo "Please find the following additional installation scripts in your home directory:"
echo "- yay AUR helper: 3-yay.sh"
echo "- snapper-support: 4-snapper.sh"
echo "- zram swap: 5-zram.sh"
echo "- preload application cache: 6-preload.sh"
echo "- qemu virtualization: 7-kvm.sh"
echo "- nvidia drivers: 8-nvidia.sh"
echo "- applications: 9-apps.sh"
echo "- hyprland install: 10-hyprland.sh"
echo "- dotfiles: 11-configs.sh"
echo "- githubs & flatpaks: 12-gitflats.sh"
echo ""
echo "Please exit & shutdown (shutdown -h now), remove the installation media and start again."
echo "Important: Activate WIFI after restart with nmtui."
