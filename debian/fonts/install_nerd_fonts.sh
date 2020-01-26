#!/bin/bash
set -euo pipefail

cd $(mktemp -d)
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.0.0/Mononoki.zip
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.0.0/Go-Mono.zip
unzip '*.zip' -d ~/.fonts
fc-cache -vf ~/.fonts/

