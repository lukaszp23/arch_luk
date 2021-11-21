#!/bin/sh

echo "Setting time zone"
ln -sf /usr/share/zoneinfo/Europe/Warsaw /etc/localtime
hwclock --systohc

echo "Setting locale"
sed -i '/pl_PL.UTF-8/ s/#//' /etc/locale.gen
echo "KEYMAP=pl" > /etc/vconsole.conf
locale-gen

echo "Changing root password"
(echo 'root'; echo 'root') | passwd

echo "Setting hostname"
echo "Kalarepa" > /etc/hostname

echo "Creating user luk"
groupadd luk
useradd -m -G luk wheel adm luk

echo "Installing sudo"
pacman -S sudo --noconfirm
sed '/%wheel ALL=(ALL) ALL/ s/# //' /etc/sudoers > /etc/sudoers_new
visudo -c /etc/sudoers_new
rm /etc/sudoers_new

echo "Installing GRUB"
pacman -S grub --noconfirm
grub-install --target=i386-pc /dev/sda

echo "Installing Microcode"
pacman -S intel-ucode --noconfirm

echo "Generating GRUB config"
grub-mkconfig -o /boot/grub/grub.cfg

exit

echo "Installing XORG and sddm"
pacman -S xorg sddm --noconfirm

#echo "Installing NVIDIA driver"
#pacman -Ss nvidia

echo "Installing KDE Plasma"
pacman -S plasma-meta --noconfirm
#pacman -S egl-wayland

echo "Enabling services"
systemctl enable sddm
systemctl enable NetworkManager

echo "Setting KDE theme"
sed -i 's/Current=/Current=brezze/' /usr/lib/sddm/sddm.conf.d/default.conf
