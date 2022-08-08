#!/bin/bash
set -euo pipefail

cd $(mktemp -d)
wget https://noto-website-2.storage.googleapis.com/pkgs/Noto-hinted.zip
unzip '*.zip'
cp -t ~/.fonts $(find . -iname '*.otf')
fc-cache -vf ~/.fonts/
