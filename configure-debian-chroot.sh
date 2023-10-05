#!/bin/bash

printf "Executing inside chroot..."

printf "Install essential packages..."
apt-get update
apt-get -y install wget btrfs-progs

printf "Install Armbian RK3588 kernel..."
apt-get install -y linux-image-edge-rockchip-rk3588 linux-dtb-edge-rockchip-rk3588

printf "Configure GRUB2..."
apt-get install -y grub-efi
