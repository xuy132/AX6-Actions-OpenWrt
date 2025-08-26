#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part1.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
#
#修改默认IP
sed -i 's/192.168.1.1/10.0.0.2/g' package/base-files/files/bin/config_generate
#修改主机名
sed -i "s/hostname='OpenWrt'/hostname='Redmi-AX6'/g" package/base-files/files/bin/config_generate
sed -i "s/hostname='ImmortalWrt'/hostname='Redmi-AX6'/g" package/base-files/files/bin/config_generate

# Uncomment a feed source
#sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default

# Add a feed source
echo 'src-git helloworld https://github.com/fw876/helloworld' >> feeds.conf.default
#echo 'src-git passwall_packages https://github.com/xiaorouji/openwrt-passwall;packages' >> feeds.conf.default
#echo 'src-git passwall_luci https://github.com/xiaorouji/openwrt-passwall;luci' >> feeds.conf.default
echo 'src-git kenzo https://github.com/kenzok8/openwrt-packages' >> feeds.conf.default
#echo 'src-git lienol https://github.com/Lienol/openwrt-package' >> feeds.conf.default
#echo 'src-git Boos https://github.com/Boos4721/OpenWrt-Packages' >> feeds.conf.default
# 修改无线命名、加密方式及密码
sed -i "s/\${s}.disabled='0'/\${s}.country=US\nset \${s}.disabled='0'/" package/network/config/wifi-scripts/files/lib/wifi/mac80211.uc
sed -i "s/\${si}.ssid='PX'/wireless.default_radio0.ssid='PX'\nset wireless.default_radio1.ssid='Pp'/" package/network/config/wifi-scripts/files/lib/wifi/mac80211.uc
sed -i "s/\${si}.encryption='none'/\${si}.encryption='psk-mixed'\nset \${si}.key='12345678'/" package/network/config/wifi-scripts/files/lib/wifi/mac80211.uc
