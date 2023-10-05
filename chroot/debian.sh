#!/bin/bash

printf "Executing inside chroot (0)..."

printf "Installing essential packages..."
apt-get update
apt-get -y install wget btrfs-progs

printf "Installing Armbian RK3588 kernel..."
apt-get update
apt-get install -y linux-image-edge-rockchip-rk3588 linux-dtb-edge-rockchip-rk3588

printf "Installing GRUB2..."
apt-get install -y grub-efi

printf "Enabling wired network..."
systemctl enable systemd-networkd
systemctl enable systemd-resolved

printf "Installing bootloader..."
systemctl enable systemd-boot
bootctl --esp-path=/efi --boot-path=/boot install
