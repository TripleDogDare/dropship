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

sgdisk --zap-all $DISK

# Clear the partition table:

sgdisk --zap-all $DISK

# 2.3 Partition your disk(s):

# Run this if you need legacy (BIOS) booting:

# sgdisk -a1 -n1:24K:+1000K -t1:EF02 $DISK

# Run this for UEFI booting (for use now or in the future):

sgdisk     -n2:1M:+512M   -t2:EF00 $DISK

# Run this for the boot pool:

sgdisk     -n3:0:+1G      -t3:BF01 $DISK

# Choose one of the following options:

# 2.3a Unencrypted or ZFS native encryption:

# sgdisk     -n4:0:0        -t4:BF01 $DISK

# 2.3b LUKS:

sgdisk     -n4:0:0        -t4:8300 $DISK

# If you are creating a mirror or raidz topology, repeat the partitioning commands for all the disks which will be part of the pool.
