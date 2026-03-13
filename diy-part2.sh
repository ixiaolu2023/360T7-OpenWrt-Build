#!/bin/bash
# 1. 修改默认IP
sed -i 's/192.168.1.1/192.168.5.1/g' package/base-files/files/bin/config_generate

# 2. 修改主机名
sed -i 's/ImmortalWrt/OpenWrt/g' package/base-files/files/bin/config_generate

# 3. 设置默认密码 (password)
sed -i 's/root:::0:99999:7:::/root:$1$V4UetPzk$CYXbxq2pRaw5eKhU79vpg1:18856:0:99999:7:::/g' package/base-files/files/etc/shadow

# 4. 修改 WiFi SSID (针对 MTK 闭源驱动路径)
# ImmortalWrt 在 MT7981 上通常使用 mtk-wifi 模块
if [ -f package/mtk/applications/luci-app-mtk/root/etc/config/wireless ]; then
    sed -i 's/ssid=ImmortalWrt/ssid=OpenWrt-2.4G/g' package/mtk/applications/luci-app-mtk/root/etc/config/wireless
    sed -i 's/ssid=ImmortalWrt-5G/ssid=OpenWrt-5G/g' package/mtk/applications/luci-app-mtk/root/etc/config/wireless
fi

# 5. 替换默认主题为 Argon
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile

# 6. 预下载 OpenClash 内核
mkdir -p package/luci-app-openclash/root/etc/openclash/core

# 7. 设置内核下载地址 (使用 Meta/Mihomo 内核，适配 360T7 的 ARMv8 架构)
CORE_URL="https://raw.githubusercontent.com/vernesong/OpenClash/core/master/meta/clash-linux-arm64.tar.gz"

# 8. 下载并解压
curl -sL $CORE_URL -o /tmp/clash_meta.tar.gz
tar -zxf /tmp/clash_meta.tar.gz -C /tmp
# 9. 重命名并移动到插件目录
mv /tmp/clash package/luci-app-openclash/root/etc/openclash/core/clash_meta

# 10.赋予可执行权限
chmod +x package/luci-app-openclash/root/etc/openclash/core/clash_meta
