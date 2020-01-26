#!/bin/bash
apt install xbacklight

mkdir -p /etc/X11/xorg.conf.d
cat <<EOF > /etc/X11/xorg.conf.d/20-intel.conf
Section "Device"
    Identifier  "Intel Graphics" 
    Driver      "intel"
    Option      "Backlight"  "intel_backlight"
EndSection
EOF