#!/bin/bash
set -euo pipefail
source config.sh

sudo chroot $CHROOT_PATH /bin/bash -c "$(cat <<'EOF'

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
PACKAGES+=('zfs-dkms')  # zfs capabilities
PACKAGES+=('gparted')  # gui partition management

# Thinkpad 
PACKAGES+=('acpi-call-dkms')  # for tlp
# No linux drivers for Fibocom L850-GL (wwan module)

#i3 packages
PACKAGES+=('rofi') #dmenu replacement
PACKAGES+=('i3')
PACKAGES+=('i3lock')
PACKAGES+=('i3blocks')
PACKAGES+=('acpi')
PACKAGES+=('sysstat')
PACKAGES+=('x11-xserver-utils')
PACKAGES+=('arandr')

REMOVE=()
REMOVE+=('vim-tiny')

apt-get remove "${REMOVE[@]}"
apt-get install --no-install-recommends "${PACKAGES[@]}"
apt-get clean
passwd root

exit	
EOF
)"


