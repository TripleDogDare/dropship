#!/bin/bash
set -euo pipefail

sudo dpkg --add-architecture i386
sudo apt update
sudo apt install steam
