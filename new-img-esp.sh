#!/bin/bash

printf "Creating disk image..."
dd if=/dev/zero of=fs.img bs=16M count=256 status=progress
losetup -Pf fs.img

printf "Partitioning..."
sfdisk /dev/loop0 < part-tables/4gb-esp-extboot.txt

printf "Creating filesystems..."
mkfs.fat -F32 -n esp /dev/loop0p1
mkfs.fat -F32 -n extboot /dev/loop0p2
mkfs.btrfs -L root /dev/loop0p3

losetup -d /dev/loop0
