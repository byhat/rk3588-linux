#!/bin/bash

echo "Executing inside chroot (0)..."

echo "Installing essential packages..."
apt-get update
apt-get -y install wget btrfs-progs initramfs-tools

echo "Installing Armbian RK3588 kernel..."
apt-get update
apt-get install -y linux-image-edge-rockchip-rk3588 linux-dtb-edge-rockchip-rk3588

echo "Installing systemd components..."
apt-get install -y systemd-boot systemd-resolved

echo "Enabling wired network..."
systemctl enable systemd-networkd
systemctl enable systemd-resolved

echo "Installing bootloader..."
bootctl --esp-path=/efi --boot-path=/boot install
