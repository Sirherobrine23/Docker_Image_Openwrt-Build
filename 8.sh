#!/bin/bash
echo " "

cd openwrt
echo -e "$(nproc) thread compile"
make -j$(nproc) || make -j1 || make -j1 V=s