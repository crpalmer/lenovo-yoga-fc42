KERNEL_VERSION=6.16.2+

all:
	$(MAKE) liveos 
	$(MAKE) liveiso.patches 
	$(MAKE) mkiso

.PHONY: mkiso
mkiso:
	rm -rf crpalmer-fc42.aarch64.iso
	cd liveiso.patches && sudo ../mkksiso.sh $(KERNEL_VERSION)

.PHONY: liveiso.patches
liveiso.patches: liveos.patched
	sudo rm -rf $@
	# kernel:
	mkdir -p $@/boot/aarch64/loader $@/boot/dtbs
	sudo cp -p /boot/vmlinuz-$(KERNEL_VERSION) $@/boot/aarch64/loader/linux
	sudo cp -p /boot/initramfs-$(KERNEL_VERSION).img $@/boot/aarch64/loader/initrd
	sudo cp -pr /boot/dtbs/$(KERNEL_VERSION) $@/boot/dtbs/
	# liveos
	sudo mkdir -p $@/LiveOS
	sudo mkfs.erofs -z zstd,3 $@/LiveOS/squashfs.img liveos.patched

.PHONY: liveos.patched
liveos.patched:
	sudo rm -rf liveos.patched
	sudo cp -rp liveos liveos.patched
	sudo du -hs liveos liveos.patched
	# Modules
	sudo cp -r /lib/modules/$(KERNEL_VERSION) liveos.patched/lib/modules/
	# TODO: compress
	# find livesos.patched/lib/modules -name '*.ko' -exec xz {} \; -exec rm -f {} \;

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
