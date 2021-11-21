#!/bin/sh

echo "Setting time zone"
ln -sf /usr/share/zoneinfo/Europe/Warsaw /etc/localtime
hwclock --systohc

echo "Setting locale."
sed -i '/pl_PL.UTF-8/ s/#//' /etc/locale.gen
echo "KEYMAP=pl" > /etc/vconsole.conf
locale-gen

echo "Changing root password."
(echo 'root'; echo 'root') | passwd

echo "Setting hostname."
echo "Kalarepa" > /etc/hostname

echo "Installing GRUB."
pacman -S grub --noconfirm
grub-install --target=i386-pc /dev/sda

echo "Generating GRUB config."
grub-mkconfig -o /boot/grub/grub.cfg

echo "Installing XORG."
pacman -S xorg --noconfirm