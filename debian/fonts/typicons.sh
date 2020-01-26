#!/bin/bash
set -euo pipefail
set -x

cd $(mktemp -d)

wget https://github.com/stephenhutchings/typicons.font/archive/2.0.7.tar.gz
tar -xf *.tar.gz
cp "$(find . -iname *.ttf)" ~/.fonts
fc-cache -vf ~/.fonts/
