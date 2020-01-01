#!/bin/bash
set -euo pipefail
set -x

YOURUSERNAME=
do [[ -z ${YOURUSERNAME} ]];do
	read -p 'Username: ' YOURUSERNAME
done

# 6.6 Create a user account:

zfs create rpool/home/${YOURUSERNAME}
adduser ${YOURUSERNAME}
cp -a /etc/skel/. /home/${YOURUSERNAME}
chown -R ${YOURUSERNAME}:${YOURUSERNAME} /home/${YOURUSERNAME}

# 6.7 Add your user account to the default set of groups for an administrator:
usermod -a -G audio,cdrom,dip,floppy,netdev,plugdev,sudo,video ${YOURUSERNAME}
