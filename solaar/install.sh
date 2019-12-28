#!/bin/bash
set -euo pipefail

LIST_FILE='/etc/apt/sources.list.d/solaar.list'

echo 'deb http://pwr.github.io/Solaar/packages/ ./' > $LIST_FILE
echo 'deb-src http://pwr.github.io/Solaar/packages/ ./' >> $LIST_FILE

apt-get update
apt-get install solaar
