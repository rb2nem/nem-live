#!/bin/bash
kvm -m 1024  -boot d -cdrom nembox-live.iso -vga vmware -usb -usbdevice tablet
