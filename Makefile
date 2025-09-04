KERNEL_VERSION=6.17.0-rc4-raw+

all:
	$(MAKE) liveos 
	$(MAKE) liveiso.patches 
	$(MAKE) mkiso

.PHONY: mkiso
mkiso:
	rm -rf crpalmer-fc42.aarch64.iso
	cd liveiso.patches && sudo ../mkksiso.sh $(KERNEL_VERSION)

.PHONY: liveiso.patches
liveiso.patches:
	sudo rm -rf $@
	# kernel:
	mkdir -p $@/boot/aarch64/loader $@/boot/dtbs
	sudo cp -p /boot/vmlinuz-$(KERNEL_VERSION) $@/boot/aarch64/loader/linux
	make $@/boot/aarch64/loader/initrd
	sudo cp -pr /boot/dtbs/$(KERNEL_VERSION) $@/boot/dtbs/
	# liveos
	make liveos.patched
	sudo mkdir -p $@/LiveOS
	sudo mkfs.erofs -z zstd,3 $@/LiveOS/squashfs.img liveos.patched

.PHONY: liveos.patched
liveos.patched:
	sudo rm -rf $@
	sudo cp -rp liveos $@
	# Modules
	sudo rm -rf $@/lib/modules/*
	sudo cp -rp /lib/modules/$(KERNEL_VERSION) $@/lib/modules/
	# Firmware
	sudo rm -rf $@/lib/firmware
	sudo cp -rp /lib/firmware $@/lib/

.PHONY: liveiso.patches/boot/aarch64/loader/initrd
liveiso.patches/boot/aarch64/loader/initrd:
	make initrd.patched
	mkdir -p `dirname $@`
	pwd && (cd initrd.patched && sudo find . | sudo cpio --quiet -H newc -o) | zstd > $@

.PHONY: initrd.patched
initrd.patched: initrd initramfs
	sudo rm -rf $@
	sudo cp -rp initrd $@
	sudo rm -rf $@/lib/firmware $@/lib/modules
	sudo cp -rp initramfs/lib/firmware $@/lib/
	sudo cp -rp initramfs/lib/modules $@/lib/

initrd: iso/boot/aarch64/loader/initrd
	rm -rf $@
	mkdir -p $@
	zstdcat iso/boot/aarch64/loader/initrd | ( cd $@ && sudo cpio --extract )

.PHONY: initramfs
initramfs:
	sudo rm -rf $@
	mkdir -p $@
	sudo zstdcat /boot/initramfs-$(KERNEL_VERSION).img | ( cd $@ && sudo cpio --extract )

liveos: iso
	mkdir -p liveos.mnt
	sudo mount iso/LiveOS/squashfs.img liveos.mnt
	sudo cp -rp liveos.mnt liveos
	sudo umount liveos.mnt

iso: Fedora-Workstation-Live-42-1.1.aarch64.iso
	mkdir -p iso.mnt
	sudo mount -o loop ./Fedora-Workstation-Live-42-1.1.aarch64.iso iso.mnt/
	sudo cp -rp iso.mnt iso
	sudo umount iso.mnt
