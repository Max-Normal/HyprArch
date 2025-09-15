#!/bin/bash
#  ____                                     
# / ___| _ __   __ _ _ __  _ __   ___ _ __  
# \___ \| '_ \ / _` | '_ \| '_ \ / _ \ '__| 
#  ___) | | | | (_| | |_) | |_) |  __/ |    
# |____/|_| |_|\__,_| .__/| .__/ \___|_|    
#                   |_|   |_|               
#  
# by Zachary Albertyn (2023) 
# ----------------------------------------------------- 
# Install Script for Snapper-Support
# ------------------------------------------------------
# Name: Snapper-Support Install Script
# DESC: All required steps to install snapper-support
# WARNING: Run this script at your own risk.

# -----------------------------------------------------
# Confirm Start
# -----------------------------------------------------
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
yay -S snapper-support
sudo umount /.snapshots
sudo rm -r /.snapshots
sudo snapper -c root create-config /
sudo btrfs subvolume list /
sudo btrfs subvolume delete /.snapshots
sudo mkdir /.snapshots
sudo mount -av
sudo snapper ls
sudo grub-mkconfig -o /boot/grub/grub.cfg
sudo systemctl enable --now grub-btrfsd
sudo systemctl status grub-btrfsd

echo "DONE!"