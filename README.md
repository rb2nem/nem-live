How to use:

  * you need to run on a Linux system. Tested on ubuntu.
  * sudo apt-get install debootstrap syslinux squashfs-tools genisoimage memtest86+  # other packages might be required, let me know
  * git clone
  * cd nem-live
  * download jre and nis tgz and save them here (jre-8u45-linux-x64.tar.gz and nis-ncc-0.6.31.tgz)
  * place your wallet file in wallets/
  * ./build_chroot.sh && build_iso.sh
  * If you have kvm, you can test it out with ./boot.sh

To do:
  * make it work with other jre and nis version
  * include page opened by browser while ncc starts up
