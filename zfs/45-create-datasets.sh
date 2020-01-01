#!/bin/bash
set -uo pipefail
# We don't exit on failure because that allows us 
# to continue if we add a dataset to existing datasets

# 3.1 Create filesystem datasets to act as containers:

zfs create -o canmount=off -o mountpoint=none rpool/ROOT
zfs create -o canmount=off -o mountpoint=none bpool/BOOT

#On Solaris systems, the root filesystem is cloned and the suffix is incremented for major system changes through pkg image-update or beadm. Similar functionality for APT is possible but currently unimplemented. Even without such a tool, it can still be used for manually created clones.

#3.2 Create filesystem datasets for the root and boot filesystems:

zfs create -o canmount=noauto -o mountpoint=/ rpool/ROOT/debian
zfs mount rpool/ROOT/debian

zfs create -o canmount=noauto -o mountpoint=/boot bpool/BOOT/debian
zfs mount bpool/BOOT/debian

#With ZFS, it is not normally necessary to use a mount command (either mount or zfs mount). This situation is an exception because of canmount=noauto.

#3.3 Create datasets:

zfs create                                 rpool/home
zfs create -o mountpoint=/root             rpool/home/root
zfs create -o canmount=off                 rpool/var
zfs create -o canmount=off                 rpool/var/lib
zfs create                                 rpool/var/log
zfs create                                 rpool/var/spool

#The datasets below are optional, depending on your preferences and/or software choices.

#If you wish to exclude these from snapshots:

zfs create -o com.sun:auto-snapshot=false  rpool/var/cache
zfs create -o com.sun:auto-snapshot=false  rpool/var/tmp
chmod 1777 /mnt/var/tmp

#If you use /opt on this system:

zfs create                                 rpool/opt

#If you use /srv on this system:

#zfs create                                 rpool/srv

#If you use /usr/local on this system:

zfs create -o canmount=off                 rpool/usr
zfs create                                 rpool/usr/local

#If this system will have games installed:

zfs create                                 rpool/var/games

#If this system will store local email in /var/mail:

zfs create                                 rpool/var/mail

#If this system will use Snap packages:

zfs create                                 rpool/var/snap

#If you use /var/www on this system:

zfs create                                 rpool/var/www

#If this system will use GNOME:

zfs create                                 rpool/var/lib/AccountsService

#If this system will use Docker (which manages its own datasets & snapshots):

zfs create -o com.sun:auto-snapshot=false  rpool/var/lib/docker

#If this system will use NFS (locking):

zfs create -o com.sun:auto-snapshot=false  rpool/var/lib/nfs

#A tmpfs is recommended later, but if you want a separate dataset for /tmp:

# zfs create -o com.sun:auto-snapshot=false  rpool/tmp
# chmod 1777 /mnt/tmp
