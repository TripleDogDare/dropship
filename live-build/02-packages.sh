#!/bin/bash
set -euo pipefail

source config.sh
cd $TARGET_DIR

echo "deb https://download.sublimetext.com/ apt/stable/" | tee config/archives/sublime_text.list.binary > config/archives/sublime_text.list.chroot
wget 'https://download.sublimetext.com/sublimehq-pub.gpg' -O - | tee config/archives/sublime_text.key.binary > config/archives/sublime_text.key.chroot


export CLOUD_SDK_REPO="cloud-sdk-$RELEASE"
echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | tee config/archives/google-cloud-sdk.list.binary > config/archives/google-cloud-sdk.list.chroot
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | tee config/archives/google-cloud-sdk.key.binary > config/archives/google-cloud-sdk.key.chroot

PACKAGE=S()

#System packages
PACKAGES+=('apt-transport-https')
PACKAGES+=('systemd') # init system
PACKAGES+=('tlp') # power management
PACKAGES+=('network-manager')
PACKAGES+=('net-tools') # arp, ifconfig, netstat, rarp, nameif, route, etc.
PACKAGES+=('wireless-tools') #iwconfig, iwlist, iwspy, iwpriv, ifrename
PACKAGES+=('wpagui') #graphical interface for wpa_supplicant
PACKAGES+=('dpkg-dev')
PACKAGES+=('powertop')
PACKAGES+=('htop')

# disk management
PACKAGES+=('gdisk')
PACKAGES+=('parted')
PACKAGES+=('gparted')  # gui partition management

# X server
PACKAGES+=('xserver-xorg-core')
PACKAGES+=('xserver-xorg')
PACKAGES+=('xinit')

# ssh
PACKAGES+=('openssh-server')
PACKAGES+=('openssh-client')

# complete desktop env
PACKAGES+=('lxde')

# Sofware
PACKAGES+=('xterm')
PACKAGES+=('curl')
PACKAGES+=('wget')
PACKAGES+=('nano')
PACKAGES+=('neovim')
PACKAGES+=('git')
PACKAGES+=('sublime-text') # requires custom repository
PACKAGES+=('google-cloud-sdk') # requires custom repository
PACKAGES+=('xprintidle') # gets idle time
PACKAGES+=('moreutils')  # things like sponge
PACKAGES+=('silversearcher-ag')

# Python
PACKAGES+=('python2.7')
PACKAGES+=('python3')
PACKAGES+=('virtualenv')
PACKAGES+=('python-pip')
PACKAGES+=('python3-venv')
PACKAGES+=('python3-pip')


#Media
PACKAGES+=('vlc')
PACKAGES+=('pavucontrol')

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

# other
PACKAGES+=('grub2-common') # checks that bootloader will work

#Steam
#PACKAGES+=('libx11-6')
#PACKAGES+=('libc6-i386') # wait, why do I want 32bit?

set -x
printf '%s\n' "${PACKAGES[@]}" > config/package-lists/my.list.chroot

