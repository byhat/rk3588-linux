losetup -Pf fs.img

mkdir fs-mountpoint
mount -o compress=zstd /dev/loop0p3 fs-mountpoint
mkdir fs-mountpoint/efi
mkdir fs-mountpoint/boot
mount /dev/loop0p1 fs-mountpoint/efi
mount /dev/loop0p2 fs-mountpoint/boot

debootstrap --arch arm64 testing fs-mountpoint http://deb.debian.org/debian/

genfstab -t PARTUUID fs-mountpoint > fs-mountpoint/etc/fstab

mount --bind /dev fs-mountpoint/dev
mount -t proc proc fs-mountpoint/proc
mount -t sysfs sys fs-mountpoint/sys
chroot fs-mountpoint
