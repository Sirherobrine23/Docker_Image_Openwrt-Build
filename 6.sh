#!/bin/bash
cd /home/copiler/
echo " "
[ -e files ] && mv files openwrt/files
[ -e $CONFIG_FILE ] && mv $CONFIG_FILE openwrt/.config
chmod +x /home/copiler/$DIY_P2_SH
cd openwrt
sudo bash /home/copiler/$DIY_P2_SH