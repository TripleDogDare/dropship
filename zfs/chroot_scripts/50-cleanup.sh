#!/bin/bash
set -euo pipefail
set -x

# Step 9: Final Cleanup

# 9.1 Wait for the system to boot normally. Login using the account you created. Ensure the system (including networking) works normally.

# 9.2 Optional: Delete the snapshots of the initial installation:

# sudo zfs destroy bpool/BOOT/debian@install
# sudo zfs destroy rpool/ROOT/debian@install

# 9.3 Optional: Disable the root password

sudo usermod -p '*' root

# 9.4 Optional: Re-enable the graphical boot process:

# If you prefer the graphical boot process, you can re-enable it now. If you are using LUKS, it makes the prompt look nicer.

# sudo vi /etc/default/grub
# Add quiet to GRUB_CMDLINE_LINUX_DEFAULT
# Comment out GRUB_TERMINAL=console
# Save and quit.
mv /etc/default/grub.bak /etc/default/grub

sudo update-grub

# Note: Ignore errors from osprober, if present.

# 9.5 Optional: For LUKS installs only, backup the LUKS header:

source /root/DISK
sudo cryptsetup luksHeaderBackup /dev/disk/by-id/${DISK}-part4 \
    --header-backup-file luks1-header.dat

# Store that backup somewhere safe (e.g. cloud storage). It is protected by your LUKS passphrase, but you may wish to use additional encryption.

# Hint: If you created a mirror or raidz topology, repeat this for each LUKS volume (luks2, etc.).
