#!/bin/bash
set -euo pipefail

cd $(mktemp -d)

wget https://github.com/supermarin/YosemiteSanFranciscoFont/archive/master.zip
unzip '*.zip' -d ~/.fonts
fc-cache -vf ~/.fonts/
