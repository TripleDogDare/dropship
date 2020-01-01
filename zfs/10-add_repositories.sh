#!/bin/bash
set -euo pipefail

echo deb http://deb.debian.org/debian buster contrib > /etc/apt/sources.list.d/debian_buster_contrib.list
echo deb http://deb.debian.org/debian buster-backports main contrib > /etc/apt/sources.list.d/debian_buster_backports.list
apt update
