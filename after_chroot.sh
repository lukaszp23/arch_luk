#!/bin/sh

echo "Setting time zone"
ln -sf /usr/share/zoneinfo/Europe/Warsaw /etc/localtime
hwclock --systohc

echo "Setting locale."
sed -i '/pl_PL.UTF-8/ s/#//' /etc/locale.gen
echo "KEYMAP=pl" > /etc/vconsole.conf
locale-gen

echo "Changing root password."
passwd

echo "Setting hostname."
echo "Kalarepa" > /etc/hostname

echo "Installing GRUB."
yes | pacman -S grub
grub-install --target=i386-pc /dev/sda

echo "Generating GRUB config."
grub-mkconfig -o /boot/grub/grub.cfg

echo "Installing XORG."
yes | pacman -S xorg