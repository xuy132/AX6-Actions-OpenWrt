#!/bin/sh

uci set luci.main.lang='zh_cn'
uci commit luci

uci set system.@system[0].timezone=CST-8
uci set system.@system[0].zonename=Asia/Shanghai
uci commit system

# 修改无线配置
uci set wireless.@wifi-iface[0].ssid='Pp'
uci set wireless.@wifi-iface[0].encryption='psk2+ccmp'
uci set wireless.@wifi-iface[0].key='12345678'
uci set wireless.default_radio0.skip_inactivity_poll='1'
uci set wireless.radio0.cell_density='0'
uci set wireless.radio0.country='CN'
uci commit wireless
#

REPO_URL=$1
if [ -z "$REPO_URL" ]; then
    REPO_URL='Unknown'
fi
REPO_BRANCH=$2
if [ -z "$REPO_BRANCH" ]; then
    REPO_BRANCH='Unknown'
fi
COMMIT_HASH=$3
if [ -z "$COMMIT_HASH" ]; then
    COMMIT_HASH='Unknown'
fi
DEVICE_NAME=$4
if [ -z "$DEVICE_NAME" ]; then
    DEVICE_NAME='Unknown'
fi
WIFI_SSID=$5
if [ -z "$WIFI_SSID" ]; then
    WIFI_SSID='Unknown'
fi
WIFI_KEY=$6
if [ -z "$WIFI_KEY" ]; then
    WIFI_KEY='Unknown'
fi

# Modify default NTP server
echo 'Modify default NTP server...'
sed -i 's/cn.ntp.org.cn/pool.ntp.org/' package/emortal/default-settings/files/99-default-settings-chinese
sed -i 's/ntp.ntsc.ac.cn/cn.ntp.org.cn/' package/emortal/default-settings/files/99-default-settings-chinese
sed -i 's/ntp.tencent.com/ntp.ntsc.ac.cn/' package/emortal/default-settings/files/99-default-settings-chinese
sed -i 's/ntp1.aliyun.com/ntp.aliyun.com/' package/emortal/default-settings/files/99-default-settings-chinese

# Modify default LAN ip
echo 'Modify default LAN IP...'
sed -i 's/192.168.1.1/10.0.0.2/' package/base-files/files/bin/config_generate

# sysctl -a
# fix v2ray too many open files
# fs.file-max = 41549
# increase APR kernel parameters for arp ram full load
# net.ipv4.neigh.default.gc_thresh1 = 128
# net.ipv4.neigh.default.gc_thresh2 = 512
# net.ipv4.neigh.default.gc_thresh3 = 1024
# net.netfilter.nf_conntrack_max = 26112
sed -i '/customized in this file/a fs.file-max=102400\nnet.ipv4.neigh.default.gc_thresh1=512\nnet.ipv4.neigh.default.gc_thresh2=2048\nnet.ipv4.neigh.default.gc_thresh3=4096\nnet.netfilter.nf_conntrack_max=65535' package/base-files/files/etc/sysctl.conf

# 修改无线命名、加密方式及密码
sed -i "s/\${s}.disabled='0'/\${s}.country=US\nset \${s}.disabled='0'/" package/network/config/wifi-scripts/files/lib/wifi/mac80211.uc
sed -i "s/\${si}.ssid='ImmortalWrt'/wireless.default_radio0.ssid='PX'\nset wireless.default_radio1.ssid='Pp'/" package/network/config/wifi-scripts/files/lib/wifi/mac80211.uc
sed -i "s/\${si}.encryption='none'/\${si}.encryption='psk-mixed'\nset \${si}.key='12345678'/" package/network/config/wifi-scripts/files/lib/wifi/mac80211.uc

# Modify default banner
echo 'Modify default banner...'
build_date=$(date +"%Y-%m-%d %H:%M:%S")
echo "                                                               " >  package/base-files/files/etc/banner
echo " ██████╗ ██████╗ ███████╗███╗   ██╗██╗    ██╗██████╗ ████████╗ " >> package/base-files/files/etc/banner
echo "██╔═══██╗██╔══██╗██╔════╝████╗  ██║██║    ██║██╔══██╗╚══██╔══╝ " >> package/base-files/files/etc/banner
echo "██║   ██║██████╔╝█████╗  ██╔██╗ ██║██║ █╗ ██║██████╔╝   ██║    " >> package/base-files/files/etc/banner
echo "██║   ██║██╔═══╝ ██╔══╝  ██║╚██╗██║██║███╗██║██╔══██╗   ██║    " >> package/base-files/files/etc/banner
echo "╚██████╔╝██║     ███████╗██║ ╚████║╚███╔███╔╝██║  ██║   ██║    " >> package/base-files/files/etc/banner
echo " ╚═════╝ ╚═╝     ╚══════╝╚═╝  ╚═══╝ ╚══╝╚══╝ ╚═╝  ╚═╝   ╚═╝    " >> package/base-files/files/etc/banner
echo " ------------------------------------------------------------- " >> package/base-files/files/etc/banner
echo " %D %C ${build_date} by xuy132                                " >> package/base-files/files/etc/banner
echo " ------------------------------------------------------------- " >> package/base-files/files/etc/banner
echo "      REPO_URL: $REPO_URL                                      " >> package/base-files/files/etc/banner
echo "   REPO_BRANCH: $REPO_BRANCH                                   " >> package/base-files/files/etc/banner
echo "   COMMIT_HASH: $COMMIT_HASH                                   " >> package/base-files/files/etc/banner
echo "   DEVICE_NAME: $DEVICE_NAME                                   " >> package/base-files/files/etc/banner
echo " ------------------------------------------------------------- " >> package/base-files/files/etc/banner
echo "                                                               " >> package/base-files/files/etc/banner
