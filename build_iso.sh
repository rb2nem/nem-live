#!/bin/bash
sudo rm chroot/etc/resolv.conf -f
sudo rm nembox-live.iso
rm -f image/live/filesystem.squashfs && sudo mksquashfs chroot image/live/filesystem.squashfs -e boot && cd image && genisoimage -rational-rock -volid "Debian Live" -cache-inodes -joliet -full-iso9660-filenames -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -output ../nembox-live.iso . && cd ..
