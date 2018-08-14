#!/bin/bash
set -euo pipefail
source config.sh

mkdir -p "$LIVE_BOOT_PATH"

sudo debootstrap \
	--arch="$ARCH" \
	--variant="$VARIANT" \
	"$RELEASE" \
	"$LIVE_BOOT_PATH/chroot" \
	"$MIRROR"

	
