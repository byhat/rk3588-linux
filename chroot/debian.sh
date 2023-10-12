#!/bin/bash

echo "Executing inside chroot (0)..."

apt-get update

echo "Installing bootloader..."
bootctl --esp-path=/efi --boot-path=/boot install

echo "Installing Armbian RK3588 kernel..."
apt-get install -y linux-image-edge-rockchip-rk3588 linux-dtb-edge-rockchip-rk3588

# Network settings must be at the end of script

echo "Setting up wired network..."
apt-get install -y systemd-resolved
systemctl enable systemd-networkd
systemctl enable systemd-resolved
