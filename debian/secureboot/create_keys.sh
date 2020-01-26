#!/bin/bash
set -euo pipefail
set -x
# Sources:
# https://ubuntu.com/blog/how-to-sign-things-for-secure-boot

# Config for the certificate generation
# Replace values under req_distinguished_name
readonly CONFIG='
HOME                    = .
RANDFILE                = $ENV::HOME/.rnd

[ req ]
distinguished_name      = req_distinguished_name
x509_extensions         = v3
string_mask             = utf8only
prompt                  = no

[ req_distinguished_name ]
commonName              = Secure Boot Signing

[ v3 ]
subjectKeyIdentifier    = hash
authorityKeyIdentifier  = keyid:always,issuer
basicConstraints        = critical,CA:FALSE
extendedKeyUsage        = codeSigning,1.3.6.1.4.1.311.10.3.6,1.3.6.1.4.1.2312.16.1.2
nsComment               = "OpenSSL Generated Certificate"
'

create_signing_keys() {
	# how long certificate should be valid
	# generally forever or the lifespan of the computer whichever comes first
	local DAYS=$((365*20))
	# add -nodes to skip password creation
	# must export KBUILD_SIGN_PIN='yourpassword' for later steps
	openssl req -config <(echo "$CONFIG") -new -x509 -newkey rsa:2048 -keyout MOK.priv -outform DER -out MOK.der -days "$DAYS" -passout env:KBUILD_SIGN_PIN "$@"
}

if [[ -z ${KBUILD_SIGN_PIN:-} ]];then
	>&2 echo "key password must be stored in KBUILD_SIGN_PIN"
	exit 1
fi

if [[ ! -f MOK.der ]];then
	create_signing_keys
fi

# register key if it is not enrolled
# will require a reboot
if [[ -z $(mokutil --test-key MOK.der | tee /dev/stderr | grep "MOK.der is already enrolled") ]]; then
	sudo mokutil --import MOK.der
	>&2 echo 'Reboot required to import key'
	exit 1
fi
