#!/bin/bash
set -euo pipefail
# alternative to using xbrightness

# create script
cat <<EOF >/usr/local/brightness
#!/bin/bash
set -euo pipefail

max_brightness=$(cat /sys/class/backlight/intel_backlight/max_brightness)
brightness=$(cat /sys/class/backlight/intel_backlight/brightness)

# echo "max: $max_brightness"
# echo "cur: $brightness"
percent=${1:-}
[ ! -z "${percent}" ] && {
	# echo "mod%: ${percent}"
	let mod=(${percent}*${max_brightness})/100 || true
	# echo "mod: $mod"
	let new=${brightness}+${mod}
	# echo "new: $new"
	if (($new > $max_brightness)); then
		let new=$max_brightness
	elif (($new < 1)); then
		let new=1
	fi
	sudo bash -c "echo $new > /sys/class/backlight/intel_backlight/brightness"
}
# echo "fin: $(cat /sys/class/backlight/intel_backlight/brightness)"
notify-send Brightness "${brightness}/${max_brightness}" -t 200
EOF

# set permissions
chown root:root /usr/local/brightness
chmod +x /usr/local/brightness
echo "$USER $HOSTNAME = NOPASSWD: /usr/local/brightness" > /etc/sudoers.d/i3brightness
