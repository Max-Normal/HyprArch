#!/bin/bash
clear
#     _             _       ___           _        _ _  
#    / \   _ __ ___| |__   |_ _|_ __  ___| |_ __ _| | | 
#   / _ \ | '__/ __| '_ \   | || '_ \/ __| __/ _` | | | 
#  / ___ \| | | (__| | | |  | || | | \__ \ || (_| | | | 
# /_/   \_\_|  \___|_| |_| |___|_| |_|___/\__\__,_|_|_| 
#                                                       
#  
# by Zachary Albertyn (2023) 
# ----------------------------------------------------- 
echo ""
echo "Important: Please make sure that you have followed the "
echo "manual steps in the README to partition the harddisc!"
echo "Warning: Run this script at your own risk."
echo ""

# ------------------------------------------------------
# Enter partition names
# ------------------------------------------------------
lsblk
read -p "Enter the name of the EFI partition (eg. sda1): " sda1
read -p "Enter the name of the ROOT partition (eg. sda2): " sda2
# read -p "Enter the name of the VM partition (keep it empty if not required): " sda3

# ------------------------------------------------------
# Sync time
# ------------------------------------------------------
timedatectl set-ntp true

# ------------------------------------------------------
# Format partitions
# ------------------------------------------------------
mkfs.fat -F 32 /dev/$sda1;
mkfs.btrfs -f /dev/$sda2
# mkfs.btrfs -f /dev/$sda3

# ------------------------------------------------------
# Mount points for btrfs
# ------------------------------------------------------
mount /dev/$sda2 /mnt
btrfs su cr /mnt/@
btrfs su cr /mnt/@cache
btrfs su cr /mnt/@home
btrfs su cr /mnt/@images
btrfs su cr /mnt/@snapshots
btrfs su cr /mnt/@log
umount /mnt

mount -o compress=zstd:3,noatime,subvol=@ /dev/$sda2 /mnt
mkdir -p /mnt/{boot/efi,home,.snapshots,var/{cache,log,lib/libvirt/images}}
mount -o compress=zstd:3,noatime,subvol=@cache /dev/$sda2 /mnt/var/cache
mount -o compress=zstd:3,noatime,subvol=@home /dev/$sda2 /mnt/home
mount -o compress=zstd:3,noatime,subvol=@images /dev/$sda2 /mnt/var/lib/libvirt/images
mount -o compress=zstd:3,noatime,subvol=@log /dev/$sda2 /mnt/var/log
mount -o compress=zstd:3,noatime,subvol=@snapshots /dev/$sda2 /mnt/.snapshots
mount /dev/$sda1 /mnt/boot/efi
# mkdir /mnt/vm
# mount /dev/$sda3 /mnt/vm

# ------------------------------------------------------
# Install base packages
# ------------------------------------------------------
pacstrap -K /mnt base base-devel git linux linux-firmware vim nano reflector rsync intel-ucode

# ------------------------------------------------------
# Generate fstab
# ------------------------------------------------------
genfstab -U /mnt >> /mnt/etc/fstab
cat /mnt/etc/fstab

# ------------------------------------------------------
# Install configuration scripts
# ------------------------------------------------------
mkdir -p /mnt/HyprArch
cp 2-configuration.sh /mnt/HyprArch/
cp 3-yay.sh /mnt/HyprArch/
cp 4-snapper.sh /mnt/HyprArch/
cp 5-zram.sh /mnt/HyprArch/
cp 6-preload.sh /mnt/HyprArch/
cp 7-kvm.sh /mnt/HyprArch/
cp 8-nvidia.sh /mnt/HyprArch/
cp 9-apps.sh /mnt/HyprArch/
cp 10-hyprland.sh /mnt/HyprArch/
cp 11-configs.sh /mnt/HyprArch/
cp 12-gitflats.sh /mnt/HyprArch/

# ------------------------------------------------------
# Chroot to installed sytem
# ------------------------------------------------------
arch-chroot /mnt ./HyprArch/2-configuration.sh

