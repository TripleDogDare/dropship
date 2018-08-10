#!/bin/bash
set -euo pipefail
source config.sh

sudo chroot $CHROOT_PATH

echo 'debian-live' > /etc/hostname
echo "deb http://httpredir.debian.org/debian/ ${RELEASE} main contrib non-free" >> /etc/apt/sources.list

apt-get update

PACKAGES=()
PACKAGES+=("$LINUX_IMAGE")
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
# Thinkpad 
PACKAGES+=('acpi-call')  # for tlp
PACKAGES+=('acpi-call')  # for tlp
# No linux drivers for Fibocom L850-GL (wwan module)

apt-get install --no-install-recommends "${PACKAGES[@]}"
apt-get clean
passwd root
exit	

