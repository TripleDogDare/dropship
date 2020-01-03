#!/bin/bash
set -euo pipefail

DISK=/dev/disk/by-id/${DISK_ID:-}
[[ ! -L ${DISK:-} ]] && {
	# nvme-eui.5cd2e42891404c09
	>&2 echo "Invalid disk: $DISK"
	>&2 echo 'Must set DISK_ID to a valid disk ID'
	>&2 echo 'May need to use "sudo -E"'
	>&2 ls -l /dev/disk/by-id/
	exit 1
}

set -x
# 2.4 Create the boot pool:
umount -R /mnt/ || true

zpool destroy bpool || true
zpool create -f -o ashift=12 -d \
    -o feature@async_destroy=enabled \
    -o feature@bookmarks=enabled \
    -o feature@embedded_data=disabled \
    -o feature@empty_bpobj=enabled \
    -o feature@enabled_txg=enabled \
    -o feature@extensible_dataset=enabled \
    -o feature@filesystem_limits=enabled \
    -o feature@hole_birth=disabled \
    -o feature@large_blocks=enabled \
    -o feature@lz4_compress=enabled \
    -o feature@spacemap_histogram=enabled \
    -o feature@userobj_accounting=enabled \
    -o feature@zpool_checkpoint=enabled \
    -o feature@spacemap_v2=enabled \
    -o feature@project_quota=enabled \
    -o feature@resilver_defer=enabled \
    -o feature@allocation_classes=enabled \
    -O acltype=posixacl -O canmount=off -O compression=lz4 -O devices=off \
    -O normalization=formD -O relatime=on -O xattr=sa \
    -O mountpoint=/ -R /mnt bpool ${DISK}-part3

# 2.5 Create the root pool:

# Choose one of the following options:

# 2.5a Unencrypted:

# zpool create -o ashift=12 \
#     -O acltype=posixacl -O canmount=off -O compression=lz4 \
#     -O dnodesize=auto -O normalization=formD -O relatime=on -O xattr=sa \
#     -O mountpoint=/ -R /mnt rpool ${DISK}-part4

# 2.5b LUKS:

apt install --yes cryptsetup

zpool destroy rpool || true

cryptsetup luksClose luks1 || true
cryptsetup luksFormat -c aes-xts-plain64 -s 512 -h sha256 ${DISK}-part4
cryptsetup luksOpen ${DISK}-part4 luks1

zpool create -o ashift=12 \
    -O acltype=posixacl -O canmount=off -O compression=lz4 \
    -O dnodesize=auto -O normalization=formD -O relatime=on -O xattr=sa \
    -O mountpoint=/ -R /mnt rpool /dev/mapper/luks1

# 2.5c ZFS native encryption:

# zpool create -o ashift=12 \
#     -O acltype=posixacl -O canmount=off -O compression=lz4 \
#     -O dnodesize=auto -O normalization=formD -O relatime=on -O xattr=sa \
#     -O encryption=aes-256-gcm -O keylocation=prompt -O keyformat=passphrase \
#     -O mountpoint=/ -R /mnt rpool ${DISK}-part4

