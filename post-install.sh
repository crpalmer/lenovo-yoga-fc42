#!/bin/bash

R=/mnt/sysroot

echo "Removing SELinux from default grub command-line"
perl -pi -e 's/selinux=0//' $R/etc/default/grub

V=`sed 's/Linux version //' /proc/version | sed 's/ .*//'`
echo "Configuring kernel $V"

mkdir -p $R/boot/loader/entries/
echo "Copy kernel"
cp /run/initramfs/live/boot/aarch64/loader/linux $R/boot/vmlinuz-$V
echo "Copy initramfs"
cp /run/initramfs/live/boot/aarch64/loader/initrd $R/boot/initramfs-$V.img
echo "Copy DTBs"
cp -r /run/initramfs/live/boot/dtbs $R/boot/dtbs

echo "Add the boot/loader/entries entry"
cat <<EOF > $R/boot/loader/entries/crpalmer-$V.conf
title Fedora Linux ($V) 42 (Workstation Edition)
version $V
linux /vmlinuz-$V
initrd /initramfs-$V.img \$tuned_initrd
options root=UUID=5d2ae3f8-2218-4174-b1f9-591b34a48c92 ro rootflags=subvol=root \$tuned_params
grub_users \$grub_users
grub_arg --unrestricted
grub_class fedora
devicetree /dtbs/$V/qcom/x1e80100-lenovo-yoga-slim7x.dtb
EOF

echo "Running grub2-mkconfig"
sudo chroot $R grub2-mkconfig -o /boot/grub2/grub.conf
