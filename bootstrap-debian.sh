#!/bin/bash
losetup -Pf fs.img

echo "Create basic directory layout..."
mkdir fs-mountpoint
mount -o compress=zstd /dev/loop0p3 fs-mountpoint
mkdir fs-mountpoint/efi
mkdir fs-mountpoint/boot
mount /dev/loop0p1 fs-mountpoint/efi
mount /dev/loop0p2 fs-mountpoint/boot

echo "Bootstrapping..."
debootstrap --include=btrfs-progs,initramfs-tools,grub-efi,ca-certificates \
  --arch arm64 \
  testing \
  fs-mountpoint \
  http://deb.debian.org/debian/

genfstab -t PARTUUID fs-mountpoint > fs-mountpoint/etc/fstab

echo "Setting up auxiliary repo..."
wget -O armbian.key https://raw.githubusercontent.com/armbian/build/main/config/armbian.key
gpg --dearmor < armbian.key > armbian.gpg
cp armbian.gpg fs-mountpoint/etc/apt/keyrings/
cp apt/armbian.list fs-mountpoint/etc/apt/sources.list.d/

mount --bind /dev fs-mountpoint/dev
mount -t proc proc fs-mountpoint/proc
mount -t sysfs sys fs-mountpoint/sys

echo "Setting up chroot scripts..."
cp -R chroot fs-mountpoint/root/

chroot fs-mountpoint /root/chroot/debian.sh

echo "Copying bootloader configs..."
cp grub/10-linux fs-mountpoint/etc/grub.d/

echo "Configuring networks..."
cp systemd-networkd/20-wired.network fs-mountpoint/etc/systemd/network/
ln -sf ../run/systemd/resolve/stub-resolv.conf fs-mountpoint/etc/resolv.conf
