#!/bin/bash
set -euo pipefail

# i3 wm start tutorials
# https://www.youtube.com/watch?v=j1I63wGcvU4
# https://www.youtube.com/watch?v=8-S0cWnLBKg
# https://www.youtube.com/watch?v=ARKIwOlazKI

# install gtk theme/icon packs
# apt-get install thunar # file explore
# apt-get install gnome-icon-theme-full # old icons?
# Or use lxappearance to set GTK Theme to mint


# natural/reverse scrolling
#  https://askubuntu.com/questions/91426/reverse-two-finger-scroll-direction-natural-scrolling
# Enable natural vertical scrolling on the touchpad
#  personal preference I guess
# mkdir -p /etc/X11/xorg.conf.d
# cp /usr/share/X11/xorg.conf.d/50-synaptics.conf /etc/X11/xorg.conf.d/
# add following lines to catchall section
        # Option "VertScrollDelta" "-111"
# if this doesn't work maybe try: https://askubuntu.com/questions/382110/how-can-i-permanently-change-touchpad-settings
#  put synclient commands into /etc/X11/Xsession.d/80synaptics
# Actually. No. I'll do an exec_always in the i3 config

PACKAGES=()
PACKAGES+=('lxappearance') # can be used to modify gtk
PACKAGES+=('rofi') # dmenu replacement
PACKAGES+=('i3')
# apt-get install i3status  #totally dropped this for i3blocks ┐(￣ヘ￣)┌
PACKAGES+=('i3lock')
PACKAGES+=('i3blocks')
PACKAGES+=('acpi') # needed for battery data
PACKAGES+=('lm-sensors') # needed for cpu temp data
PACKAGES+=('sysstat') # needed for cpu data
PACKAGES+=('x11-xserver-utils' 'arandr') # display configuration
PACKAGES+=('xss-lock')

apt-get install -y "${PACKAGES[@]}"

# TODO
# locking
#   laptop lid suspend/hibernate
#   customize lock screen, i3lock-color?
# terminal emulators:
#   Still using terminator might be okay to switch though.
# applets
#   Want nm-applet to work properly-ish
#   Want a decent blutooth applet
#   It appears you can interact with the blocks in i3blocks
#     I'll need to figure out how to do that.
