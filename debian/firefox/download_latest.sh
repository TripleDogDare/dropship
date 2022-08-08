#!/bin/bash
set -euo pipefail
set -x

sudo mkdir -p /opt/firefox
cd /opt/firefox
# AGENT='Lynx/2.9.0dev.6 libwww-FM/2.14 SSL-MM/1.4.1 GNUTLS/3.7.1'

readonly PROTOCOL='https://'
# HOST='ftp.mozilla.org'
readonly HOST='releases.mozilla.org'
readonly URL='/pub/firefox/releases/'
readonly FQD="${PROTOCOL}${HOST}${URL}"

# Only consider versions that start with a number
readonly VERSION_LIST=$(lynx -dump -nolist "${FQD}" | awk '{ if ($2 ~ /^[0-9]/) print $2}' | sort -n)
>&2 tail -10 <<< $VERSION_LIST

# select version path that does not contain letters to remove beta channels
readonly VERSION_SELECT=$(awk '{ if ($1 !~ /[a-zA-Z]/ ) print $1}' <<< "$VERSION_LIST" | tail -1)
>&2 echo "selecting: $VERSION_SELECT"

TARGET1="$FQD"
TARGET1+="$VERSION_SELECT"
readonly TARGET1
sudo wget --span-hosts --domains "${HOST}" --level=1 --no-clobber --no-parent --recursive --accept "SHA512*,SHA256*,KEY" "$TARGET1"

TARGET2="$FQD"
TARGET2+="$VERSION_SELECT"
TARGET2+="linux-x86_64/en-US/"
readonly TARGET2
sudo wget --span-hosts --domains "${HOST}" --level=1 --no-clobber --no-parent --recursive --reject "index.html*" "$TARGET2"
