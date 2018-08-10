#!/bin/bash
set -euo pipefail

mkdir -P "$LIVE_BOOT_PATH"

sudo debootstrap \
	--arch="$ARCH" \
	--variant="$VARIANT" \
	"$RELEASE" \
	"$LIVE_BOOT_PATH/chroot" \
	"$MIRROR"

	
