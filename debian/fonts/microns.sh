#!/bin/bash
set -euo pipefail
set -x

cd $(mktemp -d)
wget https://github.com/stephenhutchings/microns/archive/v1.0.6.tar.gz
tar -xzf *.tar.gz
cp "$(find . -iname *.ttf)" ~/.fonts
fc-cache -vf ~/.fonts/
