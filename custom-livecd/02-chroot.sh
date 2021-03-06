#!/bin/bash
set -euo pipefail
source config.sh
sudo cp config.sh "$CHROOT_PATH/config.sh"

sudo chroot $CHROOT_PATH /bin/bash -c "$(cat <<'EOF'

set -x
mount -t proc proc proc/
trap 'umount proc' 0 1 2 3 15

source /config.sh
rm /config.sh
export LC_ALL
export XKBLAYOUT

echo 'debian-live' > /etc/hostname
echo "deb http://httpredir.debian.org/debian/ ${RELEASE} main contrib non-free" >> /etc/apt/sources.list

apt-get update
PACKAGES=()
PACKAGES+=("$LINUX_IMAGE")
PACKAGES+=("$LINUX_HEADERS")
PACKAGES+=('live-boot')
PACKAGES+=('systemd-sysv')
PACKAGES+=('tlp')
PACKAGES+=('git')
PACKAGES+=('network-manager')
PACKAGES+=('net-tools')
PACKAGES+=('wireless-tools')
PACKAGES+=('wpagui')
PACKAGES+=('curl')
PACKAGES+=('wget')
PACKAGES+=('openssh-client')
PACKAGES+=('blackbox')
PACKAGES+=('xserver-xorg-core')
PACKAGES+=('xserver-xorg')
PACKAGES+=('xinit')
PACKAGES+=('xterm')
PACKAGES+=('nano')
PACKAGES+=('neovim')
PACKAGES+=('openssh-server')
PACKAGES+=('debootstrap')
PACKAGES+=('gdisk')
PACKAGES+=('dpkg-dev')
PACKAGES+=('parted')
PACKAGES+=('gparted')  # gui partition management

# Thinkpad 
PACKAGES+=('acpi-call-dkms')  # for tlp
# No linux drivers for Fibocom L850-GL (wwan module)
PACKAGES+=('firmware-iwlwifi')  # intel firmware for wifi

#i3 packages
PACKAGES+=('rofi') #dmenu replacement
PACKAGES+=('i3')
PACKAGES+=('i3lock')
PACKAGES+=('i3blocks')
PACKAGES+=('acpi')
PACKAGES+=('sysstat')
PACKAGES+=('x11-xserver-utils')
PACKAGES+=('arandr')

# zfs things
PACKAGES+=('zfs-dkms')  # zfs capabilities
PACKAGES+=('zfsutils-linux')
PACKAGES+=('zfs-initramfs')

REMOVE=()
REMOVE+=('vim-tiny')

apt-get remove "${REMOVE[@]}"
apt-get install -y --no-install-recommends "${PACKAGES[@]}"
apt-get clean

exit	
EOF
)"

