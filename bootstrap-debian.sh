losetup -Pf fs.img

printf "Create basic directory layout..."
mkdir fs-mountpoint
mount -o compress=zstd /dev/loop0p3 fs-mountpoint
mkdir fs-mountpoint/efi
mkdir fs-mountpoint/boot
mount /dev/loop0p1 fs-mountpoint/efi
mount /dev/loop0p2 fs-mountpoint/boot

printf "Bootstrapping..."
debootstrap --arch arm64 testing fs-mountpoint http://deb.debian.org/debian/

genfstab -t PARTUUID fs-mountpoint > fs-mountpoint/etc/fstab

printf "Configuring networks..."
cp systemd-networkd/20-wired.network fs-mountpoint/etc/systemd/network/
ln -sf ../run/systemd/resolve/stub-resolv.conf fs-mountpoint/etc/resolv.conf

printf "Setting up auxiliary repo..."
wget https://raw.githubusercontent.com/armbian/build/main/config/armbian.key
gpg --dearmor < armbian.key > armbian.gpg
cp armbian.gpg fs-mountpoint/etc/apt/keyrings/
cp apt/armbian.list fs-mountpoint/etc/apt/sources.list.d/

mount --bind /dev fs-mountpoint/dev
mount -t proc proc fs-mountpoint/proc
mount -t sysfs sys fs-mountpoint/sys

printf "Setting up chroot scripts..."
cp -R chroot fs-mountpoint/root/

chroot fs-mountpoint /root/chroot/debian.sh

printf "Copying systemd-boot configs..."
cp systemd-boot/loader.conf fs-mountpoint/efi/loader/
cp systemd-boot/linux.conf fs-mountpoint/boot/loader/entries/
