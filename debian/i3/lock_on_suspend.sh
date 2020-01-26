#!/bin/bash
set -euo pipefail

# https://gist.github.com/victorhaggqvist/603125bbc0f61a787d89
# https://wiki.archlinux.org/index.php/Session_lock#SystemD_triggers
# https://wiki.archlinux.org/index.php/Display_Power_Management_Signaling
# xssstate
# xss-lock
# xset q

# systemctl list-units --type=target

cat <<EOF > /etc/systemd/system/suspendlock@.service
[Unit]
Description=User suspend actions
Before=suspend.target hibernate.target sleep.target hybrid-sleep.target suspend-then-hibernate.target

[Service]
User=%i
Type=forking
Environment=DISPLAY=:0
Environment=SDL_VIDEO_FULLSCREEN_HEAD=0
ExecStart=/usr/bin/i3lock -f -e -c 24343f
ExecStartPost=/usr/bin/sleep 1

[Install]
WantedBy=suspend.target hibernate.target sleep.target hybrid-sleep.target suspend-then-hibernate.target
EOF

systemctl enable suspendlock@$(logname).service
# systemctl disable suspendlock@$(logname).service

# test
# systemctl suspend