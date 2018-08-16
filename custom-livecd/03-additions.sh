#!/bin/bash
set -euo pipefail
source config.sh

cd $CHROOT_PATH
git clone -- 'https://github.com/tripledogdare/dropship'
git clone -- 'https://github.com/TripleDogDare/dotfiles'
mkdir fonts
cd fonts
wget -c 'https://github.com/supermarin/YosemiteSanFranciscoFont/archive/master.zip'
wget -c 'https://github.com/FortAwesome/Font-Awesome/archive/v4.7.0.zip'

