#!/bin/bash
set -euo pipefail
source config.sh

ISO_FILE="$(find $TARGET_DIR -maxdepth 1 -type f -name '*.iso')"
ISO_COUNT=$(echo "$ISO_FILE" | wc -l)

[ "$ISO_COUNT" -gt 1 ] && {
	>&2 echo "found multiple iso files"
	>&2 echo "$ISO_FILE"
	exit 1
}

[ -z "$ISO_FILE" ] && {
	>&2 echo 'could not find iso file. please build binary'
	exit 1
}

sudo kvm -cdrom "$ISO_FILE" -m 2G -nographic -nodefaults -serial stdio

