# by Manper 20250309

include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-Minifanctrl-Tdtech
PKG_VERSION:=1.1
PKG_RELEASE:=1

LUCI_TITLE:=LuCI for Minifanctrl-Tdtech
LUCI_PKGARCH:=all
LUCI_DEPENDS:=+kmod-hwmon-pwmfan

include $(TOPDIR)/feeds/luci/luci.mk

# $(eval $(call BuildPackage,luci-app-Minifanctrl)
