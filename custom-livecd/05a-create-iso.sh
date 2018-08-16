#!/bin/bash
set -euo pipefail
source config.sh

# Create a grub UEFI image.

grub-mkstandalone \
    --format=x86_64-efi \
    --output="$LIVE_BOOT_PATH/scratch/bootx64.efi" \
    --locales="" \
    --fonts="" \
    "boot/grub/grub.cfg=$LIVE_BOOT_PATH/scratch/grub.cfg"

# Create FAT16 disk image
(cd $LIVE_BOOT_PATH/scratch && \
    dd if=/dev/zero of=efiboot.img bs=1M count=10 && \
    mkfs.vfat efiboot.img && \
    mmd -i efiboot.img efi efi/boot && \
    mcopy -i efiboot.img ./bootx64.efi ::efi/boot/
)

# Create grub BIOS image
grub-mkstandalone \
    --format=i386-pc \
    --output=$LIVE_BOOT_PATH/scratch/core.img \
    --install-modules="linux normal iso9660 biosdisk memdisk search tar ls" \
    --modules="linux normal iso9660 biosdisk search" \
    --locales="" \
    --fonts="" \
    "boot/grub/grub.cfg=$LIVE_BOOT_PATH/scratch/grub.cfg"

# feels a bit more hacky than others
# Use cat to combine a bootable Grub cdboot.img bootloader with our boot image.
cat \
    /usr/lib/grub/i386-pc/cdboot.img \
    $LIVE_BOOT_PATH/scratch/core.img \
    > $LIVE_BOOT_PATH/scratch/bios.img

# Generate the ISO file.

xorriso \
    -as mkisofs \
    -iso-level 3 \
    -full-iso9660-filenames \
    -volid "DEBIAN_CUSTOM" \
    -eltorito-boot \
        boot/grub/bios.img \
        -no-emul-boot \
        -boot-load-size 4 \
        -boot-info-table \
        --eltorito-catalog boot/grub/boot.cat \
    --grub2-boot-info \
    --grub2-mbr /usr/lib/grub/i386-pc/boot_hybrid.img \
    -eltorito-alt-boot \
        -e EFI/efiboot.img \
        -no-emul-boot \
    -append_partition 2 0xef ${LIVE_BOOTPATH}/scratch/efiboot.img \
    -output "${LIVE_BOOT_PATH}/debian-custom.iso" \
    -graft-points \
        "${LIVE_BOOT_PATH}/image" \
        /boot/grub/bios.img=${LIVE_BOOT_PATH}/scratch/bios.img \
        /EFI/efiboot.img=$LIVE_BOOT_PATH}/scratch/efiboot.img

