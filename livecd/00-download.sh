#!/bin/bash
set -euo pipefail
wget -c "${ISO_URL}" --output-document="${ISO_FILE}"
sha512sum --check --strict <<< "${SHA512}  ${ISO_FILE}"

