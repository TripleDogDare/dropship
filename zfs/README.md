Scripts for zfs on root
---

Really bad instructions

1. Execute scripts in order.
2. zfs-install needs to be run until completion across reboots
3. after install-debian you will need to run the chroot scripts in order
4. after configure-debian you should be able to boot into system

# Retrying. Should destroy everything
```
sudo umount -R /mnt/
sudo zpool destroy rpool
sudo zpool destroy bpool
```
