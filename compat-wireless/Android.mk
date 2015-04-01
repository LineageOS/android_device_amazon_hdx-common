ifneq ($(TARGET_PRODUCT),$(filter $(TARGET_PRODUCT),bueller))

LOCAL_PATH := $(call my-dir)
ifeq ($(call is-platform-sdk-version-at-least,16),true)
	DLKM_DIR := $(LOCAL_PATH)/../dlkm
else
	DLKM_DIR := $(LOCAL_PATH)/../dlkm
endif

ifeq ($(BOARD_HAS_ATH_WLAN), true)

export BUILD_ATH6KL_VER_32=1
export HAVE_CFG80211=1

include $(CLEAR_VARS)
LOCAL_MODULE             := cfg80211.ko
LOCAL_MODULE_TAGS        := debug
LOCAL_MODULE_PATH        := $(TARGET_OUT)/lib/modules/ath6kl
include $(DLKM_DIR)/AndroidKernelModule.mk

include $(CLEAR_VARS)
LOCAL_MODULE             := ath6kl_sdio.ko
LOCAL_MODULE_KBUILD_NAME := wlan.ko
LOCAL_MODULE_TAGS        := debug
LOCAL_MODULE_PATH        := $(TARGET_OUT)/lib/modules/ath6kl
include $(DLKM_DIR)/AndroidKernelModule.mk
endif

ifeq ($(BOARD_HAS_ATH_ETH_ALX), true)

export BUILD_ATH_ETH_ALX=1

include $(CLEAR_VARS)
LOCAL_MODULE             := compat.ko
LOCAL_MODULE_TAGS        := debug
LOCAL_MODULE_PATH        := $(TARGET_OUT)/lib/modules/compat
include $(DLKM_DIR)/AndroidKernelModule.mk

include $(CLEAR_VARS)
LOCAL_MODULE             := alx.ko
LOCAL_MODULE_KBUILD_NAME := eth.ko
LOCAL_MODULE_TAGS        := optional debug
LOCAL_MODULE_PATH        := $(TARGET_OUT)/lib/modules/alx
include $(DLKM_DIR)/AndroidKernelModule.mk

endif

ifeq ($(BOARD_HAS_ATH_WLAN_AR6004), true)

export BUILD_ATH6KL_VER_35=1

ifeq ($(BOARD_HAS_ATH6KL_3_5_4), true)
export HAVE_ATH6KL_3_5_4=1
endif

ifeq ($(call is-board-platform,msm8974),true)
export HAVE_BUS_VOTE=1
endif

ifeq ($(call is-board-platform,msm8960),true)
export HAVE_BUS_VOTE=1
endif

ifeq ($(BOARD_HAS_CFG80211_KERNEL3_4), true)
export HAVE_CFG80211=0
export HAVE_CFG80211_KERNEL3_4=1
export HAVE_CFG80211_KERNEL3_7=0
else
ifeq ($(BOARD_HAS_CFG80211_KERNEL3_7), true)
export HAVE_CFG80211=0
export HAVE_CFG80211_KERNEL3_4=1
export HAVE_CFG80211_KERNEL3_7=1
endif
ifeq ($(BOARD_HAS_CFG80211_KERNEL3_10), true)
export HAVE_CFG80211=0
export HAVE_CFG80211_KERNEL3_10=1
else
export HAVE_CFG80211=1
export HAVE_CFG80211_KERNEL3_4=0
export HAVE_CFG80211_KERNEL3_7=0

include $(CLEAR_VARS)
LOCAL_MODULE             := cfg80211.ko
LOCAL_MODULE_TAGS        := debug
LOCAL_MODULE_PATH        := $(TARGET_OUT)/lib/modules/ath6kl-3.5
include $(DLKM_DIR)/AndroidKernelModule.mk
endif
endif

ifeq ($(BOARD_CONFIG_ATH6KL_USB), true)
include $(CLEAR_VARS)
LOCAL_MODULE             := ath6kl_usb.ko
LOCAL_MODULE_TAGS        := optional debug
LOCAL_MODULE_KBUILD_NAME := wlan.ko
LOCAL_MODULE_PATH        := $(TARGET_OUT)/lib/modules/ath6kl-3.5
include $(DLKM_DIR)/AndroidKernelModule.mk

# WLAN SYMLINKS

include $(CLEAR_VARS)

# wpa_supplicant.conf
LOCAL_MODULE := wpa_supplicant_link
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := FAKE

include $(BUILD_SYSTEM)/base_rules.mk

$(LOCAL_BUILT_MODULE): TARGET := /system/etc/wifi/wpa_supplicant_ath6kl.conf
$(LOCAL_BUILT_MODULE): SYMLINK := $(TARGET_OUT)/etc/wifi/wpa_supplicant.conf
$(LOCAL_BUILT_MODULE): wpa_supplicant.conf
	$(hide) echo "Symlink: $(SYMLINK) -> $(TARGET)"
	$(hide) mkdir -p $(dir $@)
	$(hide) mkdir -p $(dir $(SYMLINK))
	$(hide) rm -rf $@
	$(hide) rm -rf $(SYMLINK)
	$(hide) ln -sf $(TARGET) $(SYMLINK)
	$(hide) touch $@

include $(CLEAR_VARS)

# WCNSS_qcom_cfg.ini
LOCAL_MODULE := WCNSS_qcom_cfg_link
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := FAKE

include $(BUILD_SYSTEM)/base_rules.mk

$(LOCAL_BUILT_MODULE): TARGET := /data/misc/wifi/WCNSS_qcom_cfg.ini
$(LOCAL_BUILT_MODULE): SYMLINK := $(TARGET_OUT)/etc/firmware/wlan/prima/WCNSS_qcom_cfg.ini
$(LOCAL_BUILT_MODULE):
	$(hide) echo "Symlink: $(SYMLINK) -> $(TARGET)"
	$(hide) mkdir -p $(dir $@)
	$(hide) mkdir -p $(dir $(SYMLINK))
	$(hide) rm -rf $@
	$(hide) rm -rf $(SYMLINK)
	$(hide) ln -sf $(TARGET) $(SYMLINK)
	$(hide) touch $@

include $(CLEAR_VARS)

# WCNSS_qcom_wlan_nv.bin
LOCAL_MODULE := WCNSS_qcom_wlan_nv_link
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := FAKE

include $(BUILD_SYSTEM)/base_rules.mk

$(LOCAL_BUILT_MODULE): TARGET := /persist/WCNSS_qcom_wlan_nv.bin
$(LOCAL_BUILT_MODULE): SYMLINK := $(TARGET_OUT)/etc/firmware/wlan/prima/WCNSS_qcom_wlan_nv.bin
$(LOCAL_BUILT_MODULE):
	$(hide) echo "Symlink: $(SYMLINK) -> $(TARGET)"
	$(hide) mkdir -p $(dir $@)
	$(hide) mkdir -p $(dir $(SYMLINK))
	$(hide) rm -rf $@
	$(hide) rm -rf $(SYMLINK)
	$(hide) ln -sf $(TARGET) $(SYMLINK)
	$(hide) touch $@

include $(CLEAR_VARS)

# hw1.3/bdata.bin
LOCAL_MODULE := hw1.3_bdata_link
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := FAKE

include $(BUILD_SYSTEM)/base_rules.mk

$(LOCAL_BUILT_MODULE): TARGET := /system/etc/firmware/ath6k/AR6004/hw1.3/bdata.bin_usb
$(LOCAL_BUILT_MODULE): SYMLINK := $(TARGET_OUT)/etc/firmware/ath6k/AR6004/hw1.3/bdata.bin
$(LOCAL_BUILT_MODULE):
	$(hide) echo "Symlink: $(SYMLINK) -> $(TARGET)"
	$(hide) mkdir -p $(dir $@)
	$(hide) mkdir -p $(dir $(SYMLINK))
	$(hide) rm -rf $@
	$(hide) rm -rf $(SYMLINK)
	$(hide) ln -sf $(TARGET) $(SYMLINK)
	$(hide) touch $@

include $(CLEAR_VARS)

# hw1.3/fw.ram.bin
LOCAL_MODULE := hw1.3_fw.ram_link
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := FAKE

include $(BUILD_SYSTEM)/base_rules.mk

$(LOCAL_BUILT_MODULE): TARGET := /system/etc/firmware/ath6k/AR6004/hw1.3/fw.ram.bin_usb
$(LOCAL_BUILT_MODULE): SYMLINK := $(TARGET_OUT)/etc/firmware/ath6k/AR6004/hw1.3/fw.ram.bin
$(LOCAL_BUILT_MODULE):
	$(hide) echo "Symlink: $(SYMLINK) -> $(TARGET)"
	$(hide) mkdir -p $(dir $@)
	$(hide) mkdir -p $(dir $(SYMLINK))
	$(hide) rm -rf $@
	$(hide) rm -rf $(SYMLINK)
	$(hide) ln -sf $(TARGET) $(SYMLINK)
	$(hide) touch $@

include $(CLEAR_VARS)

# hw3.0/bdata.bin
LOCAL_MODULE := hw3.0_bdata_link
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := FAKE

include $(BUILD_SYSTEM)/base_rules.mk

ifeq ($(TARGET_DEVICE),apollo)
$(LOCAL_BUILT_MODULE): TARGET := /system/etc/firmware/ath6k/AR6004/hw3.0/boardData_Apollo_FCC.bin
endif
ifeq ($(TARGET_DEVICE),thor)
$(LOCAL_BUILT_MODULE): TARGET := /system/etc/firmware/ath6k/AR6004/hw3.0/boardData_Thor_FCC.bin
endif
$(LOCAL_BUILT_MODULE): SYMLINK := $(TARGET_OUT)/etc/firmware/ath6k/AR6004/hw3.0/bdata.bin
$(LOCAL_BUILT_MODULE):
	$(hide) echo "Symlink: $(SYMLINK) -> $(TARGET)"
	$(hide) mkdir -p $(dir $@)
	$(hide) mkdir -p $(dir $(SYMLINK))
	$(hide) rm -rf $@
	$(hide) rm -rf $(SYMLINK)
	$(hide) ln -sf $(TARGET) $(SYMLINK)
	$(hide) touch $@

include $(CLEAR_VARS)

# wlan.ko
LOCAL_MODULE := wlan_ko_link
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := FAKE

include $(BUILD_SYSTEM)/base_rules.mk

$(LOCAL_BUILT_MODULE): TARGET := /system/lib/modules/ath6kl-3.5/ath6kl_usb.ko
$(LOCAL_BUILT_MODULE): SYMLINK := $(TARGET_OUT)/lib/modules/wlan.ko
$(LOCAL_BUILT_MODULE):
	$(hide) echo "Symlink: $(SYMLINK) -> $(TARGET)"
	$(hide) mkdir -p $(dir $@)
	$(hide) mkdir -p $(dir $(SYMLINK))
	$(hide) rm -rf $@
	$(hide) rm -rf $(SYMLINK)
	$(hide) ln -sf $(TARGET) $(SYMLINK)
	$(hide) touch $@

else
include $(CLEAR_VARS)
include $(LOCAL_PATH)/drivers/net/wireless/ath/ath6kl-3.5/android_sdio/Android.mk
endif

endif

endif # TARGET_PRODUCT is not bueller
