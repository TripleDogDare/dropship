#!/bin/bash
set -euo pipefail

source config.sh
USB_DEVICE=${1} # e.g. /dev/sdc

USB_DEVICES=$(find /dev/disk/by-id/ -name 'usb*' -type l | grep -vP '.*part[0-9]+$' | xargs realpath)

[[ -z $(grep -o "$USB_DEVICE" <<< "$USB_DEVICES") ]] && {
	>&2 echo "!!!! WARNING !!!!"
	>&2 echo "Selected device may not be a usb device"
}

read -n1 -r -p "Will overwrite all files on ${USB_DEVICE}. Continue(y/n)?"; echo

if [[ $REPLY =~ ^[Yy]$ ]];then
	sudo dd if="${ISO_FILE}" of="${USB_DEVICE}" bs=4M
	sync
else
	exit 2
fi

