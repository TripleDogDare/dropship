#!/bin/bash
set -euo pipefail
source config.sh

cd $TARGET_DIR

sudo lb bootstrap
sudo lb chroot

