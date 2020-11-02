#!/bin/bash
echo " "

[ -e $FEEDS_CONF ] && mv $FEEDS_CONF openwrt/feeds.conf.default
chmod +x /home/copiler/$DIY_P1_SH
cd openwrt
sudo bash /home/copiler/$DIY_P1_SH