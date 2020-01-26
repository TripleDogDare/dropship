#!/bin/bash
set -euo pipefail

cd $(mktemp -d)

wget https://github.com/FortAwesome/Font-Awesome/archive/v4.7.0.zip
wget https://use.fontawesome.com/releases/v5.11.2/fontawesome-free-5.11.2-desktop.zip
unzip '*.zip' -d ~/.fonts
fc-cache -vf ~/.fonts/
