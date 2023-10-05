losetup -Pf fs.img

mkdir fs-mountpoint
mount -o compress=zstd /dev/loop0p3 fs-mountpoint
mkdir fs-mountpoint/efi
mkdir fs-mountpoint/boot
mount /dev/loop0p1 fs-mountpoint/efi
mount /dev/loop0p2 fs-mountpoint/boot

debootstrap --arch aarch64 bookworm fs-mountpoint http://deb.debian.org/debian/

mount --bind /dev fs-mountpoint/dev
mount -t proc proc fs-mountpoint/proc
mount -t sysfs sys fs-mountpoint/sys
chroot fs-mountpoint
