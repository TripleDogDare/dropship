#!/bin/bash
set -euo pipefail

apt update
apt install --yes dpkg-dev
apt install --yes linux-headers-amd64
apt install --yes linux-image-amd64
apt install --yes zfs-initramfs
apt install --yes dosfstools
apt install --yes grub-efi-amd64
apt install --yes shim-signed

# Power and Temp controls or sensors
# apt install --yes thermald # intel only, maybe don't want this
apt install --yes acpi # I think this one is needed but could vary on platform
apt install --yes hddtemp
apt install --yes lm-sensors
apt install --yes psensor
apt install --yes smartmontools

# Platform
apt install --yes firmware-iwlwifi # intel wifi
apt install --yes firmware-linux

apt install --yes apt-transport-https
apt install --yes bash-completion
apt install --yes curl
apt install --yes git
apt install --yes htop
apt install --yes jq
apt install --yes lshw
apt install --yes lynx
apt install --yes man
apt install --yes neovim
apt install --yes pciutils # lspci
apt install --yes rsync
apt install --yes silversearcher-ag
apt install --yes tree
apt install --yes unzip
apt install --yes usbutils # lsusb
apt install --yes wget

# Networking
apt install --yes network-manager # nmcli, MAY CONFLICT WITH SYSTEMD-NETWORKD
apt intsall --yes wireless-tools #iwconfig, iwlist, iwspy, iwpriv, ifrename
apt install --yes net-tools # arp, ifconfig, netstat, rarp, nameif, route, etc
apt install --yes traceroute
apt install --yes rfkill
# apt install --yes iwd # another wireless daemon?
# apt install --yes telnet

# fuzzy finder
# https://salsa.debian.org/debian/fzf/blob/master/debian/README.Debian
# https://github.com/junegunn/fzf#using-linux-package-managers
apt install --yes fzf 

#ssh
apt install --yes openssh-server
apt install --yes openssh-client

#X11
apt install --yes xserver-xorg
apt install --yes xinit
apt install --yes x11-xserver-utils
apt install --yes arandr

apt install --yes pavucontrol
apt install --yes nautilus
apt install --yes gnome-terminal
apt install --yes rofi
apt install --yes gnome-screenshot

# https://github.com/jonls/redshift/releases
apt install --yes redshift

# Fonts
apt install --yes fonts-noto-color-emoji # Used in i3 bar


>&2 echo 'i3 install in debian/i3'
>&2 echo 'sublime install in debian/sublime_text'
>&2 echo 'steam install in debian/steam'
>&2 echo 'firefox install in debian/firefox'
