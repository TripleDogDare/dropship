#!/bin/bash
set -euo pipefail
set -x

gpg --import ./key
cd /opt/firefox/releases.mozilla.org/pub/firefox/releases
readonly VERSION="$(ls -1 | sort -n | tail -1 | tee /dev/stderr)"
cd "${VERSION}"
gpg --verify SHA256SUMS.asc SHA256SUMS
gpg --verify SHA512SUMS.asc SHA512SUMS
readonly OUTPUT512=$(sha512sum --ignore-missing --strict -c SHA512SUMS | tee /dev/stderr)
readonly OUTPUT256=$(sha256sum --ignore-missing --strict -c SHA256SUMS | tee /dev/stderr)
diff <(echo $OUTPUT256) <(echo $OUTPUT512)

readonly FORM='linux-x86_64/en-US'
readonly ARCHIVE=$(echo $OUTPUT256 | sed 's|: OK$||' | grep "$FORM" | head -1)
gpg --verify "${ARCHIVE}.asc" "${ARCHIVE}"
readonly TARGET="/opt/firefox/${VERSION}"
sudo mkdir -p "${TARGET}"
sudo tar -xf "${ARCHIVE}" -C "${TARGET}"

bfind() {
	local DIR=$(pwd -P)
	readonly DIR
	local RESULTS
	local i=0
	while [[ -z ${RESULTS:-} ]]; do
		# >&2 echo find $DIR -mindepth $i -maxdepth $i "$@"
		RESULTS=$(find $DIR -mindepth $i -maxdepth $i "$@") 
		((i++))
	done
	echo "$RESULTS"
}

cd "$TARGET"
readonly EXECUTABLE=$(bfind -type f -executable -name firefox | tee /dev/stderr | head -1)
sudo ln -sf -t /usr/local/bin "${EXECUTABLE}"
