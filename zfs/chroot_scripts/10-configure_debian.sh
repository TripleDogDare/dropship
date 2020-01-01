#!/bin/bash
set -euo pipefail
set -x

sign_module() {
	# signs the module and all the module's dependencies
	tail $(modinfo -n $1 | tee /dev/stderr) | grep "Module signature appended" || {
		/usr/src/linux-headers-$(uname -r)/scripts/sign-file sha256 ./MOK.priv ./MOK.der $(modinfo -n $1)
	}
	local MODULE
	modinfo -F depends $1 | tr ',' '\n' | while read MODULE; do
		tail $(modinfo -n $MODULE | tee /dev/stderr) | grep "Module signature appended" || {
			/usr/src/linux-headers-$(uname -r)/scripts/sign-file sha256 ./MOK.priv ./MOK.der $(modinfo -n $MODULE) > /dev/null
		}
	done
}

if [[ -z ${KBUILD_SIGN_PIN:-} ]];then
	>&2 echo "key password must be stored in KBUILD_SIGN_PIN"
	exit 1
fi


DISK=/dev/disk/by-id/${DISK_ID:-}
[[ ! -L ${DISK:-} ]] && {
	# nvme-eui.5cd2e42891404c09
	>&2 echo "Invalid disk: $DISK"
	>&2 echo 'Must set DISK_ID to a valid disk ID'
	>&2 echo 'May need to use "sudo -E"'
	>&2 ls -l /dev/disk/by-id/
	exit 1
}

# 4.5 Configure a basic system environment:

ln -sf /proc/self/mounts /etc/mtab
apt update

apt install --yes locales
dpkg-reconfigure locales

# Even if you prefer a non-English system language, always ensure that en_US.UTF-8 is available.

dpkg-reconfigure tzdata

# 4.6 Install ZFS in the chroot environment for the new system:

apt install --yes dpkg-dev linux-headers-amd64 linux-image-amd64
apt install --yes zfs-initramfs

(
	cd MOK
	sign_module zfs
)

# 4.7 For LUKS installs only, setup crypttab:

apt install --yes cryptsetup

echo luks1 UUID=$(blkid -s UUID -o value ${DISK}-part4) none \
    luks,discard,initramfs > /etc/crypttab
# The use of initramfs is a work-around for cryptsetup does not support ZFS.

# 4.8 Install GRUB
# 4.8b Install GRUB for UEFI booting
apt install dosfstools
mkdosfs -F 32 -s 1 -n EFI ${DISK}-part2
mkdir /boot/efi
echo PARTUUID=$(blkid -s PARTUUID -o value ${DISK}-part2) \
    /boot/efi vfat nofail,x-systemd.device-timeout=1 0 1 >> /etc/fstab
mount /boot/efi
apt install --yes grub-efi-amd64 shim-signed

# 4.9 Set a root password
passwd

# 4.10 Enable importing bpool

# This ensures that bpool is always imported,
# regardless of whether /etc/zfs/zpool.cache exists,
# whether it is in the cachefile or not,
# or whether zfs-import-scan.service is enabled.
cat <<EOF >/etc/systemd/system/zfs-import-bpool.service
[Unit]
DefaultDependencies=no
Before=zfs-import-scan.service
Before=zfs-import-cache.service

[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/sbin/zpool import -N -o cachefile=none bpool

[Install]
WantedBy=zfs-import.target

systemctl enable zfs-import-bpool.service
EOF

# 4.11 Optional (but recommended): Mount a tmpfs to /tmp

# If you chose to create a /tmp dataset above, skip this step,
# as they are mutually exclusive choices.
# Otherwise, you can put /tmp on a tmpfs (RAM filesystem)
# by enabling the tmp.mount unit.

cp /usr/share/systemd/tmp.mount /etc/systemd/system/
systemctl enable tmp.mount

# 4.12 Optional (but kindly requested): Install popcon
# The popularity-contest package reports the list of packages
# install on your system. Showing that ZFS is popular may
# be helpful in terms of long-term attention from the distro.
apt install --yes popularity-contest


# Step 5: GRUB Installation

# 5.1 Verify that the ZFS boot filesystem is recognized:

grub-probe /boot

# 5.2 Refresh the initrd files:

update-initramfs -u -k all
# Note: When using LUKS, this will print
# "WARNING could not determine root device from /etc/fstab".
# This is because cryptsetup does not support ZFS.

# 5.3 Workaround GRUB's missing zpool-features support:

echo 'GRUB_CMDLINE_LINUX="root=ZFS=rpool/ROOT/debian"' > /etc/default/grub.d/10-linux-zfs.cfg
echo 'GRUB_CMDLINE_LINUX_DEFAULT=""' > /etc/default/grub.d/20-linux-default-debug.cfg
echo 'GRUB_TERMINAL=console' >> /etc/default/grub.d/20-linux-default-debug.cfg

# Later, once the system has rebooted twice and
# you are sure everything is working, you can undo these changes, if desired.

# 5.5 Update the boot configuration:
update-grub

# 5.6 Install the boot loader
# 5.6b For UEFI booting, install GRUB:

grub-install --target=x86_64-efi --efi-directory=/boot/efi \
    --bootloader-id=debian --recheck --no-floppy

# 5.7 Verify that the ZFS module is installed:

ls /boot/grub/*/zfs.mod

# 5.8 Fix filesystem mount ordering

# Until there is support for mounting /boot in the initramfs, we also need to mount that, because it was marked canmount=noauto. Also, with UEFI, we need to ensure it is mounted before its child filesystem /boot/efi.

# We need to activate zfs-mount-generator. This makes systemd aware of the separate mountpoints, which is important for things like /var/log and /var/tmp. In turn, rsyslog.service depends on var-log.mount by way of local-fs.target and services using the PrivateTmp feature of systemd automatically use After=var-tmp.mount.

# For UEFI booting, unmount /boot/efi first:
umount /boot/efi

# Everything else applies to both BIOS and UEFI booting:
zfs set mountpoint=legacy bpool/BOOT/debian
echo bpool/BOOT/debian /boot zfs \
    nodev,relatime,x-systemd.requires=zfs-import-bpool.service 0 0 >> /etc/fstab

mkdir /etc/zfs/zfs-list.cache
touch /etc/zfs/zfs-list.cache/rpool
ln -sf /usr/lib/zfs-linux/zed.d/history_event-zfs-list-cacher.sh /etc/zfs/zed.d
zed -F &
ZED_PID=$!

# Verify that zed updated the cache by making sure this is not empty:
[[ -z $(cat /etc/zfs/zfs-list.cache/rpool) ]] && {
	>&2 echo 'zed update cache'
	# If it is empty, force a cache update and check again:
	zfs set canmount=noauto rpool/ROOT/debian
}

kill $ZED_PID

sed -Ei "s|/mnt/?|/|" /etc/zfs/zfs-list.cache/rpool

# Step 6: First Boot
# 6.1 Snapshot the initial installation:
zfs snapshot bpool/BOOT/debian@install
zfs snapshot rpool/ROOT/debian@install
# In the future, you will likely want to take snapshots before each upgrade, and remove old snapshots (including this one) at some point to save space.

# 6.2 Exit from the chroot environment back to the LiveCD environment:
exit

# 6.3 Run these commands in the LiveCD environment to unmount all filesystems:
mount | grep -v zfs | tac | awk '/\/mnt/ {print $3}' | xargs -i{} umount -lf {}
zpool export -a

# 6.4 Reboot:
reboot
