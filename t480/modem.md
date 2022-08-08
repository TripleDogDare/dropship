[Source](https://forums.lenovo.com/t5/Linux-Discussion/Linux-support-for-WWAN-LTE-L850-GL-on-T580-T480/td-p/4067969?page=9)
[PCI Driver WIP](https://github.com/xmm7360/xmm7360-pci)
[USB Modeswitch](https://github.com/xmm7360/xmm7360-usb-modeswitch)
[Juhovh Fork/Kernel module for USB modeswitch version](https://github.com/juhovh/xmm7360_usb)

Re:Linux support for WWAN/LTE (L850-GL) on T580/T480

It has been solved long time ago.

 

Download this: https://github.com/juhovh/xmm7360_usb

 

And do the following:

 

1) compile xmm7360_usb-master and install xmm7360_usb.ko

  there is ssl error but kernel moduel is installed but will not work

  checK:

   modinfo -n xmm7360_usb

   /lib/modules/xxx/extra/xmm7360_usb.ko

 

xxx is your kernel version

 

2) sign kernel module xmm7360_usb.ko

 

   create directory sign, enter sign, log as root

   openssl req -new -x509 -newkey rsa:2048 -keyout MOK.priv -outform DER -out MOK.der -nodes -days 36500 -subj "/CN=xmm7360_usb/"

   /usr/src/kernels/xxx/scripts/sign-file sha256 ./MOK.priv ./MOK.der $(modinfo -n xmm7360_usb)

 

 

  now inject sign key

  mokutil --import MOK.der

 

  this time will ask for a passwd, you can use any but need same passwd after reboot and import MOK key to BIOS

 

  Reboot, after bluescreen, select import MOK, select MOK, view MOK and sign

  now boot as normal

 

3) add following to /etc/rc.d/rc.local

  modprobe xmm7360_usb

   

  or /etc/modules-load.d

 

  add file xmm.conf with line xmm7360_usb

 

 

 

 

 

@ Oskarowski wrote:
 

     

    Same issue with the latest LTE modem

    https://forums.lenovo.com/t5/Other-Linux-Discussions/Linux-drivers-for-Wireless-controller-Intel-Corporation-XMM7360-LTE-Advanced-Modem/m-p/5016395

     