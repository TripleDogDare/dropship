#!/bin/bash
set -euo pipefail

cd $(mktemp -d)
wget https://noto-website-2.storage.googleapis.com/pkgs/Noto-hinted.zip
unzip '*.zip'
cp "$(find . -iname '*.otf')" ~/.fonts
cp "$(find . -iname '*.otc')" ~/.fonts
fc-cache -vf ~/.fonts/
