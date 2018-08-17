#!/bin/bash
set -euo pipefail
source config.sh

cd $CHROOT_PATH
sudo git clone -- 'https://github.com/tripledogdare/dropship'
sudo git clone -- 'https://github.com/TripleDogDare/dotfiles'
sudo mkdir fonts
cd fonts
sudo wget -c 'https://github.com/supermarin/YosemiteSanFranciscoFont/archive/master.zip'
sudo wget -c 'https://github.com/FortAwesome/Font-Awesome/archive/v4.7.0.zip'

