#!/bin/bash
set -euo pipefail

target=${1:-}

[ -z "$target" ] && {
	target="$USER"
}

if [ "$target" == 'root' ]; then
	>&2 echo "Must be normal user and not root"
	>&2 echo "Run 'sudo $0 \$USER'" 
	exit 1
fi

gpasswd -a $USER bumblebee

