#!/bin/bash
set -euo pipefail
source config.sh


# Installing a live environment to a USB device is NOT the same as writing an .iso file to a USB device.
USB_DEVICE=${1} # e.g. /dev/sdc

USB_DEVICES=$(find /dev/disk/by-id/ -name 'usb*' -type l | grep -vP '.*part[0-9]+$' | xargs realpath)

[[ -z $(grep -o "$USB_DEVICE" <<< "$USB_DEVICES") ]] && {
	>&2 echo "!!!! WARNING !!!!"
	>&2 echo "Selected device may not be a usb device"
	exit 1
}

export disk=$USB_DEVICE

# Create some mount points for the USB drive.
sudo mkdir -p /mnt/{usb,efi}

# Partition the USB drive using parted. This command creates 2 partitions in a GPT (Guid Partition Table) layout. One partition for UEFI, and one for our Debian OS and other live data.

sudo parted --script $disk \
    mklabel gpt \
    mkpart ESP fat32 1MiB 200MiB \
        name 1 EFI \
        set 1 esp on \
    mkpart primary fat32 200MiB 100% \
        name 2 LINUX \
        set 2 msftdata on

# Format the UEFI and data partitions.
sudo mkfs.vfat -F32 ${disk}1 && \
sudo mkfs.vfat -F32 ${disk}2

# Mount the partitions.
sudo mount ${disk}1 /mnt/efi && \
sudo mount ${disk}2 /mnt/usb

# Install Grub for x86_64 UEFI booting.
sudo grub-install \
    --target=x86_64-efi \
    --efi-directory=/mnt/efi \
    --boot-directory=/mnt/usb/boot \
    --removable \
    --recheck

# Create a live directory on the USB device.
sudo mkdir -p /mnt/usb/{boot/grub,live}

# Copy the Debian live environment files we previously generated to the USB disk.
sudo cp -r $LIVE_BOOT_PATH/image/* /mnt/usb/

# Copy the grub.cfg boot configuration to the USB device.
sudo cp \
    $LIVE_BOOT_PATH/scratch/grub.cfg \
    /mnt/usb/boot/grub/grub.cfg

# Now unmount the disk and you should be ready to boot from it on a UEFI system.
sudo umount /mnt/{usb,efi}

