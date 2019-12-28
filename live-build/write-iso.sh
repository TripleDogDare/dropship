#!/bin/bash
set -euo pipefail

source config.sh
set -x
ISO_FILE="$(find $TARGET_DIR -maxdepth 1 -type f -name '*.iso')"
ISO_COUNT=$(echo "$ISO_FILE" | wc -l)

[ "$ISO_COUNT" -gt 1 ] && {
	>&2 echo "found multiple iso files"
	>&2 echo "$ISO_FILE"
	exit 1
}

[ -z "$ISO_FILE" ] && {
	>&2 echo 'could not find iso file. please build binary'
	exit 1
}
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

