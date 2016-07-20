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

WCNSS_QCOM_CFG_LINK := $(TARGET_OUT)/etc/firmware/wlan/prima/WCNSS_qcom_cfg.ini
$(WCNSS_QCOM_CFG_LINK): WCNSS_QCOM_CFG_FILE := /data/misc/wifi/WCNSS_qcom_cfg.ini
$(WCNSS_QCOM_CFG_LINK): $(LOCAL_INSTALLED_MODULE) $(LOCAL_PATH)/Android.mk
	$(hide) echo "Symlink: $(WCNSS_QCOM_CFG_LINK) -> $(WCNSS_QCOM_CFG_FILE)"
	$(hide) mkdir -p $(dir $@)
	$(hide) rm -rf $@
	$(hide) ln -sf $(WCNSS_QCOM_CFG_FILE) $@

WCNSS_QCOM_WLAN_NV_LINK := $(TARGET_OUT)/etc/firmware/wlan/prima/WCNSS_qcom_wlan_nv.bin
$(WCNSS_QCOM_WLAN_NV_LINK): WCNSS_QCOM_WLAN_NV_FILE := /persist/WCNSS_qcom_wlan_nv.bin
$(WCNSS_QCOM_WLAN_NV_LINK): $(LOCAL_INSTALLED_MODULE) $(LOCAL_PATH)/Android.mk
	$(hide) echo "Symlink: $(WCNSS_QCOM_WLAN_NV_LINK) -> $(WCNSS_QCOM_WLAN_NV_FILE)"
	$(hide) mkdir -p $(dir $@)
	$(hide) rm -rf $@
	$(hide) ln -sf $(WCNSS_QCOM_WLAN_NV_FILE) $@

ATH6KL_WLAN_LINK := $(TARGET_OUT)/lib/modules/wlan.ko
$(ATH6KL_WLAN_LINK): ATH6KL_WLAN_FILE := /system/lib/modules/ath6kl-3.5/ath6kl_usb.ko
$(ATH6KL_WLAN_LINK): $(LOCAL_INSTALLED_MODULE) $(LOCAL_PATH)/Android.mk
	$(hide) echo "Symlink: $(ATH6KL_WLAN_LINK) -> $(ATH6KL_WLAN_FILE)"
	$(hide) mkdir -p $(dir $@)
	$(hide) rm -rf $@
	$(hide) ln -sf $(ATH6KL_WLAN_FILE) $@

ALL_DEFAULT_INSTALLED_MODULES += $(WCNSS_QCOM_CFG_LINK) $(WCNSS_QCOM_WLAN_NV_LINK) $(ATH6KL_WLAN_LINK)

else
include $(CLEAR_VARS)
include $(LOCAL_PATH)/drivers/net/wireless/ath/ath6kl-3.5/android_sdio/Android.mk
endif

endif

endif # TARGET_PRODUCT is not bueller
