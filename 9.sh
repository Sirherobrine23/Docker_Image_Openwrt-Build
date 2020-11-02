#!/bin/bash
echo " "
cd openwrt/bin/targets/*/*
rm -rf packages
rm -rf *.squashfs
rm -rf *.manifest
rm -rf *lzma.bin
rm -rf *.elf
rm -rf *vmlinux.bin
rm -rf *vmlinux.lzma
rm -rf *.buildinfo
cp * $uploadssh23
