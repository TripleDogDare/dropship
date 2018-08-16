#!/bin/bash
set -euo pipefail
source config.sh

mkdir -p $LIVE_BOOT_PATH/{scratch,image/live}

sudo mksquashfs \
	"$CHROOT_PATH" \
	"$LIVE_BOOT_PATH/image/live/filesystem.sqashfs" \
	-e boot

cp $CHROOT_PATH/boot/vmlinuz-* "$LIVE_BOOT_PATH/image/vmlinuz"
cp $CHROOT_PATH/boot/initrd.img-* "$LIVE_BOOT_PATH/image/initrd"

cat <<'EOF' >$LIVE_BOOT_PATH/scratch/grub.cfg

search --set=root --file /DEBIAN_CUSTOM

insmod all_video

set default="0"
set timeout=30

menuentry "Debian Live" {
    linux /vmlinuz boot=live quiet nomodeset
    initrd /initrd
}
EOF
# Create a special file in image named DEBIAN_CUSTOM.
# This file will be used to help Grub figure out which device contains our live filesystem.
# This file name must be unique and must match the file name in our grub.cfg config.
touch "$LIVE_BOOT_PATH/image/DEBIAN_CUSTOM"

