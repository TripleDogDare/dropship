#!/bin/bash
set -euo pipefail

>&2 echo 'SOURCE: https://www.sublimetext.com/docs/linux_repositories.html'

wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/sublimehq-archive.gpg
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list

sudo apt update
sudo apt-get install --yes sublime-text
