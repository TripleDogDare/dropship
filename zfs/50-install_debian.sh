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

debootstrap buster /mnt
zfs set devices=off rpool

readonly HOSTNAME=cjb

echo "${HOSTNAME}" > /mnt/etc/hostname

# add host or if the system has a real name in DNS:
echo "127.0.1.1       ${HOSTNAME}" > /mnt/etc/hosts
# echo "127.0.1.1       FQDN HOSTNAME"

# 
# Configure network interfaces
# 
# use ip addr show to learn interface names
cat <<EOF > /mnt/etc/network/interfaces.d/ens8u1
# USB-C/tethering
allow-hotplug ens8u1
iface ens8u1 inet dhcp
EOF

cat <<EOF > /mnt/etc/network/interfaces.d/lo
auto lo
iface lo inet loopback
EOF

# 
# 4.3 Configure the package sources:
# 

# add official debian
cat <<EOF >/mnt/etc/apt/sources.list
deb http://deb.debian.org/debian buster main contrib non-free
deb-src http://deb.debian.org/debian buster main contrib non-free

deb http://security.debian.org/debian-security buster/updates main contrib non-free
deb-src http://security.debian.org/debian-security buster/updates main contrib non-free
EOF

# add a mirror repo
cat <<EOF > /mnt/etc/apt/sources.list.d/debian-mirror-uchicago.list
deb http://debian.uchicago.edu/debian/ buster main contrib non-free
deb-src http://debian.uchicago.edu/debian/ buster main contrib non-free

# buster-updates, previously known as 'volatile'
deb http://debian.uchicago.edu/debian/ buster-updates main contrib non-free
deb-src http://debian.uchicago.edu/debian/ buster-updates main contrib non-free
EOF

# add backports repo
cat <<EOF > /mnt/etc/apt/sources.list.d/buster-backports.list
deb http://deb.debian.org/debian buster-backports main contrib
deb-src http://deb.debian.org/debian buster-backports main contrib
EOF

# configure zfs to come from buster-backports
cat <<EOF > /mnt/etc/apt/preferences.d/90_zfs
Package: libnvpair1linux libuutil1linux libzfs2linux libzfslinux-dev libzpool2linux python3-pyzfs pyzfs-doc spl spl-dkms zfs-dkms zfs-dracut zfs-initramfs zfs-test zfsutils-linux zfsutils-linux-dev zfs-zed
Pin: release n=buster-backports
Pin-Priority: 990
EOF

# 
# 4.4 Bind the virtual filesystems from the LiveCD environment to the new system and chroot into it:
# 
cp ./chroot_scripts/* /mnt/root/
chmod +x /mnt/root/*.sh
echo "DISK=${DISK}" > /mnt/root/DISK
mkdir -p /mnt/root/MOK
cp ./MOK.* /mnt/root/MOK/
cp ~/.inputrc /mnt/root/.inputrc

mount --rbind /dev  /mnt/dev
mount --rbind /proc /mnt/proc
mount --rbind /sys  /mnt/sys
if [[ $TERM == "mlterm" ]]; then
	export TERM=rxvt
fi
# http://www.linuxfromscratch.org/lfs/view/7.8-systemd/chapter06/chroot.html
chroot /mnt /usr/bin/env -i            \
	DISK_ID=${DISK_ID:-}               \
	TERM=${TERM:-rxvt}                 \
	DISK=${DISK:-}                     \
	HOME=/root                         \
	KBUILD_SIGN_PIN=${KBUILD_SIGN_PIN} \
    PS1='\u:\w\$ '                     \
	bash --login +h
