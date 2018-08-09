#!/bin/bash
ISO_FILE='debian-live-9.5.0-amd64-xfce.iso'
SHA512='d2b0fe266ef809943f24b71f6a7c1c7a1645a2ee0b51e71bb05625ca84f16904a8889287d580fcb5d8ff1152785f90ffdb1621733bbb148431155478b0006114'

wget -c "https://cdimage.debian.org/debian-cd/current-live/amd64/iso-hybrid/${ISO_FILE}"
sha512sum --check --strict <<< "${SHA512}  ${ISO_FILE}"

