all: liveos updates/LiveOS/squashfs.img
	cd updates && sudo mkksiso --skip-mkefiboot -a LiveOS/squashfs.img ../Fedora-Workstation-Live-42-1.1.aarch64.iso ..crpalmer-fc42.aarch64.iso
	
.PHONY: squashfs.img
updates/LiveOS/squashfs.img:
	sudo cp iso/LiveOS/squashfs.img $@
	sudo mkfs.erofs -z zstd,3 squashfs.img liveos

liveos: iso
	mkdir -p liveos.mnt && sudo mount iso/LiveOS/squashfs.img liveos.mnt && sudo cp -rp liveos.mnt liveos && sudo umount liveos.mnt

iso: Fedora-Workstation-Live-42-1.1.aarch64.iso
	mkdir -p iso.mnt && sudo mount -o loop ./Fedora-Workstation-Live-42-1.1.aarch64.iso iso.mnt/ && sudo cp -rp iso.mnt iso && sudo umount iso.mnt
