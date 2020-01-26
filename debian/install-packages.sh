#!/bin/bash
set -euo pipefail

PACKAGES=()
PACKAGES+=('firmware-iwlwifi')
PACKAGES+=('firmware-linux')
PACKAGES+=('bash-completion')

PACKAGES+=('git')
PACKAGES+=('tree')
PACKAGES+=('wget')
PACKAGES+=('curl')
PACKAGES+=('neovim')
PACKAGES+=('htop')

# https://github.com/jonls/redshift/releases
PACKAGES+=('redshift')
# fuzzy finder
# https://salsa.debian.org/debian/fzf/blob/master/debian/README.Debian
# https://github.com/junegunn/fzf#using-linux-package-managers
PACKAGES+=('fzf') 
PACKAGES+=('silversearcher-ag')


PACKAGES+=('lm-sensors')
PACKAGES+=('hddtemp')
PACKAGES+=('psensor')

PACKAGES+=('thermald') # intel only


apt update
apt install "${PACKAGES[@]}"
