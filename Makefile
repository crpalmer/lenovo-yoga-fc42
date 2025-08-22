all: liveos liveiso.patches
	rm -rf crpalmer-fc42.aarch64.iso
	cd liveiso.patches && \
	sudo mkksiso --skip-mkefiboot \
		-a . \
		../Fedora-Workstation-Live-42-1.1.aarch64.iso ../crpalmer-fc42.aarch64.iso

.PHONY: liveiso.patches
liveiso.patches: 
	mkdir -p liveos.patches
	# kernel:
	mkdir -p liveiso.patches/boot/aarch64/loader
	sudo cp -p /boot/vmlinuz-6.16.1+ liveiso.patches/boot/aarch64/loader/linux
	sudo cp -p /boot/initramfs-6.16.1+.img liveiso.patches/boot/aarch64/loader/initrd
	# liveos
	sudo mkdir -p liveiso.patches/LiveOS
	sudo mkfs.erofs -z zstd,3 liveiso.patches/LiveOS/squashfs.img liveos.patched

.PHONY: liveos.patched
liveos.patched:
	sudo rm -rf liveos.patched
	sudo cp -rp liveos liveos.patched
	# Modules
	sudo cp -r /lib/modules/6.16.1+ liveos.patched/lib/modules/

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
