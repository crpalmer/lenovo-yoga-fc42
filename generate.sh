#!/bin/bash

#sudo mkfs.erofs -z zstd,level=3 iso/LiveOS/squashfs.img livefs/

genisoimage --boot-info-table --boot-load-size 4 --no-emul-boot -b extracted-boot.bin --iso-level 3 -o crpalmer-fc42.iso -J -r -V "FC42 (crpalmer) LiveCD" iso

# doesn't get recognized as bootable
#mkisofs --boot-info-table --no-emul-boot --boot-load-size 4 -b extracted-boot.bin --iso-level 3 -c boot/boot.cat -o crpalmer-fc42.iso -J -r -V "FC42 (crpalmer) LiveCD" iso

# doesn't get recognized as bootable
#mkisofs --boot-load-size 4 --no-emul-boot -b extracted-boot.bin --iso-level 3 -o crpalmer-fc42.iso -J -r -V "FC42 (crpalmer) LiveCD" iso

# doesn't get recognized as bootable
#mkisofs --iso-level 3 -o crpalmer-fc42.iso -J -r -V "FC42 (crpalmer) LiveCD" iso
