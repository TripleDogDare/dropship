#!/bin/bash
set -euo pipefail

# https://wiki.archlinux.org/index.php/TLP
# unclear if tp-smapi-dkms is still a thing that works?
apt install tlp tp-smapi-dkms



# Thinkfan?? fancontrol??
# https://forums.opensuse.org/showthread.php/535833-Thinkfan-installation-guide

# T480
# sensors-detect
# Driver `coretemp':
#   * Chip `Intel digital thermal sensor' (confidence: 9)

# To load everything that is needed, add this to /etc/modules:
# #----cut here----
# # Chip drivers
# coretemp
# #----cut here----
# If you have some drivers built into your kernel, the list above will
# contain too many modules. Skip the appropriate ones!
