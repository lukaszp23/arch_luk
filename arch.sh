#!/bin/sh

echo "Updating system clock."
timedatectl set-ntp true

echo "Creating swap partition."
sgdisk -n 2:0:+24GiB -t 0:8200 /dev/sda

echo "Creating file system partition."
sgdisk -n 1:0:0 -t 0:8300 /dev/sda

echo "Formating partition."
mkfs.ext4 /dev/sda1

echo "Initializing swap."
mkswap /dev/sda2

echo "Mounting file system."
mount /dev/sda1 /mnt

echo "Enabling swap."
swapon /dev/sda2

echo "Enable parallel download."
sed -i '/ParallelDownloads/ s/#//' /etc/pacman.conf

echo "Installing essential packages."
pacstrap /mnt base linux linux-firmware

echo "Generating fstab."
genfstab -U /mnt >> /mnt/etc/fstab

echo "Chroot"
arch-chroot /mnt
