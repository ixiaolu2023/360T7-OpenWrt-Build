#!/bash
# 1. 修改默认IP
sed -i 's/192.168.1.1/192.168.5.1/g' package/base-files/files/bin/config_generate

# 2. 修改主机名
sed -i 's/ImmortalWrt/OpenWrt/g' package/base-files/files/bin/config_generate

# 3. 设置默认密码 (password)
sed -i 's/root:::0:99999:7:::/root:$1$V4UetPzk$CYXbxq2pRaw5eKhU79vpg1:18856:0:99999:7:::/g' package/base-files/files/etc/shadow

# 4. 修改默认WiFi SSID和加密方式
sed -i 's/ssid=ImmortalWrt/ssid=OpenWrt-2.4G/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh
# 注意：5G SSID 修改通常需要根据硬件路径，以下为通用修改方案
sed -i 's/ssid=ImmortalWrt-5G/ssid=OpenWrt-5G/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh
# 设置密码和加密
sed -i 's/encryption=none/encryption=psk2/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh
sed -i '/encryption=psk2/a \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ set wireless.default_${name}.key=12345678' package/kernel/mac80211/files/lib/wifi/mac80211.sh

# 5. 替换默认主题为 Argon
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile
