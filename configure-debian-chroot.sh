#!/bin/bash

printf "Executing inside chroot..."

printf "Install essential packages..."
apt-get update
apt-get -y install linux-image-arm64 btrfs-progs