#!/bin/bash
set -euo pipefail

sign_module() {
	# signs the module and all the module's dependencies
	tail $(modinfo -n $1 | tee /dev/stderr) | grep "Module signature appended" || {
		/usr/src/linux-headers-$(uname -r)/scripts/sign-file sha256 ./MOK.key ./MOK.der $(modinfo -n $1)
	}
	
	local DEPENDENCIES=$(modinfo -F depends $1)
	if [[ ! -z "$DEPENDENCIES" ]]; then
		local MODULE
		modinfo -F depends $1 | tr ',' '\n' | while read MODULE; do
		tail $(modinfo -n $MODULE | tee /dev/stderr) | grep "Module signature appended" || {
			/usr/src/linux-headers-$(uname -r)/scripts/sign-file sha256 ./MOK.key ./MOK.der $(modinfo -n $MODULE) > /dev/null
		}
		done
	fi
}

[[ ! -f ./MOK.key ]] && [[ -f ./MOK.priv ]] && {
	openssl rsa -in MOK.priv -out MOK.key
}

set -x
sign_module "$@"
