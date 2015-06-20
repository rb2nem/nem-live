# About

Scripts to build a live CD or USB boot disk to run NEM's Community Client.
You can include your wallets in the image built.

When you boot the image, it automatically logs you in and start a browser, opening the locally running NCC.
When you have finished, just close the browser window and it halts the computer.

This should help you take your wallet with you and use it on other computers without the need to install anything.
This could be very helpful for NEM user groups wanting to demo the client at an event booth for example.

# Limitations

This is a very early version, that is best run in a virtual machine.
If you boot yout computer with it, it is probable the X server won't start. If there is enough interest,
I could work to make it usable in many more circumstances.

# How to use

  * you need to run on a Linux system. Tested on ubuntu.
  * sudo apt-get install debootstrap syslinux squashfs-tools genisoimage memtest86+  # other packages might be required, let me know
  * git clone https://github.com/rb2nem/nem-live.git
  * cd nem-live
  * download jre and nis tgz and save them in the root of the git repo (eg jre-8u45-linux-x64.tar.gz and nis-ncc-0.6.31.tgz)
  * place your wallet file in wallets/
  * ./build_chroot.sh && build_iso.sh
  * If you have kvm, you can test it out with ./boot.sh

# To do
  * include page opened by browser while ncc starts up
  * configure NCC to use a public node (now it wants to use the local NIS)
  * improve hardware support/networking config
