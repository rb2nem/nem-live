set -e -x

sudo debootstrap wheezy ./chroot http://127.0.0.1:3142/http.debian.net/debian/

echo "deb http://http.debian.net/debian wheezy-backports main" | sudo tee --append chroot/etc/apt/sources.list >/dev/null
echo "deb http://ftp.de.debian.org/debian/ wheezy main contrib non-free" | sudo tee --append chroot/etc/apt/sources.list > /dev/null
echo 'Acquire::http { Proxy "http://127.0.0.1:3142";};' | sudo tee chroot/etc/apt/apt.conf.d/50proxy
echo 'Acquire::https{ Proxy "false"; } ; '  | sudo tee --append chroot/etc/apt/apt.conf.d/50proxy
sudo chroot chroot apt-get upgrade -y




sudo chroot chroot apt-get install -y --force-yes --no-install-recommends linux-image-amd64 curl sudo blackbox xserver-xorg-core xserver-xorg xinit xterm rungetty nvi iceweasel ca-certificates tmux live-boot-initramfs-tools live-boot live-config

sudo chroot chroot apt-get install -y --force-yes linux-image-amd64



if [[ ! -d image ]] ; then
  mkdir -p image/{live,isolinux}
  sudo mksquashfs chroot image/live/filesystem.squashfs -e boot
  cp chroot/boot/vmlinuz-3.2.0-4-amd64 image/live/vmlinuz1
  cp chroot/boot/initrd.img-3.2.0-4-amd64 image/live/initrd1

cat > image/isolinux/isolinux.cfg <<EOF
UI menu.c32

prompt 0
menu title Nembox Live

timeout 1

label Debian Live 3.2.0-4-amd64
menu label ^Debian Live 3.2.0-4-amd64
menu default
kernel /live/vmlinuz1
append initrd=/live/initrd1 boot=live
EOF


  cp /usr/lib/syslinux/isolinux.bin image/isolinux/
  cp /usr/lib/syslinux/menu.c32 image/isolinux/

fi



sudo rm chroot/etc/apt/apt.conf.d/50proxy

echo "nembox" | sudo tee chroot/etc/hostname

echo "nem:nem:1001:1001:Nem Account:/home/nem:/bin/bash" | sudo chroot chroot newusers

echo "nem ALL=(ALL:ALL) NOPASSWD:ALL" | sudo tee chroot/etc/sudoers.d/nem

#echo configure rungetty: http://www.debianadmin.com/how-to-auto-login-and-startx-without-a-display-manager-in-debian.html
sudo  sed -i -e "/1:2345:respawn:\/sbin\/getty 38400 tty1/d" chroot/etc/inittab
echo "1:2345:respawn:/bin/login -f nem tty1 </dev/tty1 >/dev/tty1 2>&1" | sudo tee --append chroot/etc/inittab
echo 'startx' | sudo tee --append  chroot/home/nem/.bash_profile


sudo tar -C chroot/usr/local/ -zxvf jre-8u45-linux-x64.tar.gz
sudo tar -C chroot/home/nem/ -zxvf nis-ncc-0.6.31.tgz


#echo "/usr/bin/xterm&"  | sudo tee chroot/home/nem/.xsession
echo 'tmux new -d -s "nem" "cd /home/nem/package && PATH=/usr/local/jre1.8.0_45/bin/:$PATH ./nix.runNcc.sh"'   | sudo tee --append chroot/home/nem/.xsession
echo "/usr/bin/blackbox&"  | sudo tee --append chroot/home/nem/.xsession
echo "iceweasel http://127.0.0.1:8989"  | sudo tee --append chroot/home/nem/.xsession
echo "sudo halt"  | sudo tee --append chroot/home/nem/.xsession
echo 'PATH=$PATH:/usr/local/jre1.8.0_45/bin/' | sudo tee --append  chroot/home/nem/.bashrc

sudo chroot chroot mkdir -p /home/nem/nem/ncc 
sudo cp wallets/* chroot/home/nem/nem/ncc/
sudo chroot chroot chown nem:nem /home/nem/nem -R








#/etc/X11/xorg.conf
#------------------

(cat <<EOF
Section "ServerLayout"
        Identifier     "BodhiZazen's KVM xorg.conf"
        Screen      0  "Screen0" 0 0
        InputDevice    "Mouse0" "CorePointer"
        InputDevice    "Keyboard0" "CoreKeyboard"
EndSection

Section "Module"
        Load  "record"
        Load  "dri"
        Load  "extmod"
        Load  "glx"
        Load  "dbe"
        Load  "dri2"
EndSection

Section "InputDevice"
        Identifier  "Keyboard0"
        Driver      "kbd"
EndSection

Section "InputDevice"
        Identifier  "Mouse0"
        Driver      "vmmouse"
        Option      "Protocol" "SysMouse"
        Option      "Device" "/dev/sysmouse"
        Option      "ZAxisMapping" "4 5 6 7"
EndSection

Section "Monitor"
        Identifier   "Monitor0"
        VendorName   "Monitor Vendor"
        ModelName    "Monitor Model"
        HorizSync       20.0 - 50.0
        VertRefresh     40.0 - 80.0
        Option          "DPMS"

EndSection

Section "Device"
        Identifier  "Card0"
        Driver      "vesa"
        VendorName  "KVM - std"
        BoardName   "GD 5446"
        BusID       "PCI:0:2:0"
EndSection

Section "Screen"
        Identifier "Screen0"
        Device     "Card0"
        Monitor    "Monitor0"
        SubSection "Display"
                Viewport   0 0
                Modes "1600x1200"
        EndSubSection
EndSection
EOF
) | sudo tee chroot/etc/X11/xorg.conf
