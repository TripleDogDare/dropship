#!/bin/bash
set -euo pipefail

PACKAGES=()
PACKAGES+=('debootstrap')
PACKAGES+=('squashfs-tools')
PACKAGES+=('xorriso')
PACKAGES+=('grub-pc-bin')
PACKAGES+=('grub-efi-amd64-bin')
PACKAGES+=('mtools')
PACKAGES+=('git')
PACKAGES+=('wget')

sudo apt-get install "${PACKAGES[@]}"

