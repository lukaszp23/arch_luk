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

echo "Installing essential packages."
pacstrap /mnt base linux linux-firmware

echo "Generating fstab"
genfstab -U /mnt >> /mnt/etc/fstab

echo "Chroot"
arch-chroot /mnt

echo "Setting time zone"
ln -sf /usr/share/zoneinfo/Europe/Warsaw /etc/localtime
hwclock --systohc

echo "Setting locale."
sed -i '/pl_PL.UTF-8/ s/#//' /etc/locale.gen
echo "KEYMAP=pl" > /etc/vconsole.conf
locale-gen

echo "Setting hostname."
echo "Kalarepa" > /etc/hostname

echo "Installing GRUB."
pacman -S grub
grub-install --target=i386-pc /dev/sd1
