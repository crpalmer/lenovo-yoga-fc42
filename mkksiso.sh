#!/bin/bash

if [ $# != 1 ]; then
  echo "usage: <kernel veresion>"
  exit 1
fi

sudo mkksiso --skip-mkefiboot \
	-a boot \
	-a LiveOS \
	--cmdline 'selinux=0' \
	--replace 'initrd ' "devicetree /boot/dtbs/$1/qcom/x1e80100-lenovo-yoga-slim7x.dtb 
initrd " \
	--rm-args "quiet rhgb" \
	../Fedora-Workstation-Live-42-1.1.aarch64.iso \
	../crpalmer-fc42.aarch64.iso
