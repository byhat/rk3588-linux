#!/bin/bash

printf "Executing inside chroot (1)..."

printf "Setting Up GRUB2..."
apt-get install -y grub-efi

printf "Enabling wired network..."
systemctl enable systemd-networkd
systemctl enable systemd-resolved
