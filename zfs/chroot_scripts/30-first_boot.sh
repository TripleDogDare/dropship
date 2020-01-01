#!/bin/bash
set -euo pipefail
set -x

# Step 8: Full Software Installation

# 8.1 Upgrade the minimal system:

apt dist-upgrade --yes

# 8.2 Install a regular set of software:

tasksel

# 8.3 Optional: Disable log compression:

# As /var/log is already compressed by ZFS, logrotate’s compression is going to burn CPU and disk I/O for (in most cases) very little gain. Also, if you are making snapshots of /var/log, logrotate’s compression will actually waste space, as the uncompressed data will live on in the snapshot. You can edit the files in /etc/logrotate.d by hand to comment out compress, or use this loop (copy-and-paste highly recommended):

for file in /etc/logrotate.d/* ; do
    if grep -Eq "(^|[^#y])compress" "$file" ; then
        sed -i -r "s/(^|[^#y])(compress)/\1#\2/" "$file"
    fi
done

# 8.4 Reboot:

reboot
