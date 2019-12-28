#!/bin/bash
set -euo pipefail
TARGET='/etc/modprobe.d/alsa-base.conf'
LINE='options snd-hda-intel model=generic'

[ -f "$TARGET" ] && {
	echo "File exists: $TARGET"
	echo "open file and add following line"
	echo "$LINE"
	exit 1
}

echo "$LINE" > "$TARGET"
exit 0

