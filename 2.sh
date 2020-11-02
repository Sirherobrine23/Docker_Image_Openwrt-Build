#!/bin/bash
echo " "

df -hT $PWD
git clone $REPO_URL -b $REPO_BRANCH /home/copiler/openwrt
sudo ln -sf /workdir/openwrt /home/copiler/openwrt