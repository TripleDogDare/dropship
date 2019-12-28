#!/bin/bash
set -euo pipefail


source config.sh
mkdir -p $TARGET_DIR
cd $TARGET_DIR
lb clean

lb config \
  --mode debian \
  --distribution $RELEASE \
  --debian-installer live \
  --architectures=${ARCHITECTURE} \
  --binary-images iso-hybrid \
  --iso-volume ${ISO_VOLUME} \
  --archive-areas "main contrib non-free" \
  --apt-secure true \
  --apt-recommends false \
  --firmware-binary true \
  --updates true \
  --security true \
  --firmware-chroot true \
  --linux-packages "linux-image linux-headers" \
  --memtest 'memtest86+'

