#!/bin/bash

# while read -r line; do
# 	echo $line
# 	symbol=$(grep -oP '^\w+' <<< "$line")
# 	echo "monitor ${symbol} is connected"
# done < <(xrandr | sed -n '/\sconnected/p')

declare -A monitors
cardPath=/sys$(udevadm info -q path -n /dev/dri/card0)
disconnected='e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855'
while read -r line; do
	sha=$(sha256sum $line | cut -d\  -f1)
	mon=$(echo -n $line | grep -oP 'card0-\K\w+-.*(\d+)')
	echo -e "${mon}\t${sha}"
	# mon=$(sed -n "s/$cardPath(.*)/\1/" <<< $line)
done < <(find $cardPath -name edid)
