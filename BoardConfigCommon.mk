BOARD_VENDOR := amazon

# headers
TARGET_SPECIFIC_HEADER_PATH := device/amazon/hdx-common/include

# Platform
TARGET_BOARD_PLATFORM := msm8974
TARGET_BOARD_PLATFORM_GPU := qcom-adreno330
TARGET_BOOTLOADER_BOARD_NAME := MSM8974

# Bootloader
TARGET_NO_BOOTLOADER := true

# Architecture
TARGET_GLOBAL_CFLAGS += -mfpu=neon-vfpv4 -mfloat-abi=softfp
TARGET_GLOBAL_CPPFLAGS += -mfpu=neon-vfpv4 -mfloat-abi=softfp
TARGET_ARCH := arm
TARGET_CPU_ABI := armeabi-v7a
TARGET_CPU_ABI2 := armeabi
TARGET_CPU_SMP := true
TARGET_ARCH_VARIANT := armv7-a-neon
TARGET_CPU_VARIANT := krait
ARCH_ARM_HAVE_TLS_REGISTER := true

# Krait optimizations
TARGET_USE_KRAIT_BIONIC_OPTIMIZATION := true
TARGET_USE_KRAIT_PLD_SET := true
TARGET_KRAIT_BIONIC_PLDOFFS := 10
TARGET_KRAIT_BIONIC_PLDTHRESH := 10
TARGET_KRAIT_BIONIC_BBTHRESH := 64
TARGET_KRAIT_BIONIC_PLDSIZE := 64

# Kernel -> use prebuilt kernel ...
ifeq ($(TARGET_DEVICE),thor)
BOARD_KERNEL_CMDLINE := console=ttyHSL0,115200,n8 androidboot.hardware=qcom user_debug=31 msm_rtb.filter=0x37 ehci-hcd.park=3 mdss_mdp.panel=0:qcom,mdss_dsi_novatek_1080p_video androidboot.selinux=permissive
BOARD_MKBOOTIMG_ARGS := --ramdisk_offset 0x01000000 --tags_offset 0x00000100
endif
ifeq ($(TARGET_DEVICE),apollo)
BOARD_KERNEL_CMDLINE := console=ttyHSL0,115200,n8 androidboot.hardware=qcom user_debug=31 msm_rtb.filter=0x37 ehci-hcd.park=3 mdss_mdp.panel=0:qcom,mdss_dsi_jdi_dualmipi0_video:1:qcom,mdss_dsi_jdi_dualmipi1_video: androidboot.selinux=permissive
BOARD_MKBOOTIMG_ARGS := --ramdisk_offset 0x01000000 --tags_offset 0x00000100
endif
BOARD_KERNEL_BASE := 0x00000000
BOARD_KERNEL_PAGESIZE := 2048

# Flags
COMMON_GLOBAL_CFLAGS += -DAMZ_HDX
COMMON_GLOBAL_CFLAGS += -DNO_SECURE_DISCARD
#-DQCOM_HARDWARE -DQCOM_BSP -DUSE_ION 

# QCOM hardware
#BOARD_USES_QCOM_HARDWARE := true
#TARGET_USES_QCOM_BSP := true
#TARGET_ENABLE_QC_AV_ENHANCEMENTS := true
#TARGET_QCOM_DISPLAY_VARIANT := caf-hdx
#TARGET_QCOM_MEDIA_VARIANT := caf-hdx
#TARGET_QCOM_AUDIO_VARIANT := caf-hdx

# Audio
AUDIO_FEATURE_DISABLED_SSR := true #MSM CAF
BOARD_USES_ALSA_AUDIO := true
BOARD_USES_LEGACY_ALSA_AUDIO := false
# test
AUDIO_FEATURE_ENABLED_COMPRESS_VOIP := true
AUDIO_FEATURE_ENABLED_EXTN_FORMATS := true
AUDIO_FEATURE_ENABLED_FLUENCE := true
AUDIO_FEATURE_ENABLED_INCALL_MUSIC := true
AUDIO_FEATURE_ENABLED_MULTI_VOICE_SESSIONS := true
AUDIO_FEATURE_ENABLED_PCM_OFFLOAD := true
AUDIO_FEATURE_ENABLED_PROXY_DEVICE := true
BOARD_USES_FLUENCE_INCALL := true
BOARD_USES_SEPERATED_AUDIO_INPUT := true
BOARD_USES_SEPERATED_VOICE_SPEAKER := true
TARGET_USES_QCOM_COMPRESSED_AUDIO := true
TARGET_USES_QCOM_MM_AUDIO := true
# test

# Bluetooth
BOARD_HAVE_BLUETOOTH := true
BOARD_HAVE_BLUETOOTH_QCOM := true
WIFI_BT_STATUS_SYNC := true
BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR := device/amazon/hdx-common/bluetooth
#BLUETOOTH_HCI_USE_MCT := true

# chargers
BOARD_CHARGER_RES := device/amazon/hdx-common/charger

# Graphics
BOARD_EGL_CFG := device/amazon/hdx-common/egl.cfg
USE_OPENGL_RENDERER := true
TARGET_USES_C2D_COMPOSITION := true
TARGET_USES_OVERLAY := true
TARGET_USES_ION := true
TARGET_DISPLAY_USE_RETIRE_FENCE := true
MAX_EGL_CACHE_KEY_SIZE := 12*1024
MAX_EGL_CACHE_SIZE := 2048*1024
OVERRIDE_RS_DRIVER := libRSDriver_adreno.so

# Surfaceflinger optimization for VD surfaces
TARGET_FORCE_HWC_FOR_VIRTUAL_DISPLAYS := true
NUM_FRAMEBUFFER_SURFACE_BUFFERS := 3

# Power
#TARGET_POWERHAL_VARIANT := qcom

# Time services
#BOARD_USES_QC_TIME_SERVICES := true

# Webkit
ENABLE_WEBGL := true
TARGET_FORCE_CPU_UPLOAD := true

# Charging mode
BOARD_CHARGING_MODE_BOOTING_LPM := 
BOARD_BATTERY_DEVICE_NAME := "bq27x41"

TARGET_USERIMAGES_USE_EXT4 := true
BOARD_BOOTIMAGE_PARTITION_SIZE := 0xA00000
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 0xA00000
BOARD_SYSTEMIMAGE_PARTITION_SIZE := 1308622848
BOARD_USERDATAIMAGE_PARTITION_SIZE := 12549340160
BOARD_FLASH_BLOCK_SIZE := 131072

# ATH6KL WLAN
BOARD_HAS_QCOM_WLAN			:= true
BOARD_WLAN_DEVICE			:= qcwcn
WPA_SUPPLICANT_VERSION			:= VER_0_8_X
BOARD_WPA_SUPPLICANT_DRIVER		:= NL80211
BOARD_WPA_SUPPLICANT_PRIVATE_LIB	:= lib_driver_cmd_$(BOARD_WLAN_DEVICE)
BOARD_HOSTAPD_DRIVER             	:= NL80211
BOARD_HOSTAPD_PRIVATE_LIB 		:= lib_driver_cmd_$(BOARD_WLAN_DEVICE)
WIFI_DRIVER_FW_PATH_STA			:= "sta"
WIFI_DRIVER_FW_PATH_AP			:= "ap"
WIFI_DRIVER_FW_PATH_P2P			:= "p2p"
WIFI_DRIVER_FW_PATH_PARAM		:= "/sys/module/wlan/parameters/fwpath"
WIFI_DRIVER_MODULE_PATH 		:= "/system/lib/modules/wlan.ko"
WIFI_DRIVER_MODULE_NAME 		:= "wlan"
# not working "wcnss_service"
#TARGET_USES_WCNSS_CTRL			:= true
#TARGET_USES_QCOM_WCNSS_QMI		:= true
#TARGET_PROVIDES_WCNSS_QMI		:= true
#TARGET_USES_WCNSS_MAC_ADDR_REV		:= true
# not working "wcnss_service"

# NFC
BOARD_HAVE_NFC := false

# Vold
BOARD_VOLD_EMMC_SHARES_DEV_MAJOR := true
BOARD_VOLD_MAX_PARTITIONS := 32
TARGET_USE_CUSTOM_LUN_FILE_PATH := /sys/devices/msm_dwc3/f9200000.dwc3/gadget/lun%d/file

# custom liblights (because we basically have none)
TARGET_PROVIDES_LIBLIGHT := true

# Temporary
USE_CAMERA_STUB := true

# CWM Recovery
TARGET_RECOVERY_FSTAB := device/amazon/hdx-common/rootdir/etc/fstab.qcom
TARGET_RECOVERY_PIXEL_FORMAT := "RGBX_8888"
BOARD_USES_MMCUTILS := true
BOARD_HAS_LARGE_FILESYSTEM := true
BOARD_HAS_NO_MISC_PARTITION := true
BOARD_HAS_NO_SELECT_BUTTON := true

# TWRP Recovery
RECOVERY_FSTAB_VERSION := 2
TARGET_RECOVERY_QCOM_RTC_FIX := true
RECOVERY_GRAPHICS_USE_LINELENGTH := true
BOARD_USE_CUSTOM_RECOVERY_FONT := \"roboto_23x41.h\"
RECOVERY_SDCARD_ON_DATA := true
TW_EXTERNAL_STORAGE_PATH := "/external_sd"
TW_EXTERNAL_STORAGE_MOUNT_POINT := "external_sd"
TARGET_USERIMAGES_USE_EXT4 := true
TW_BRIGHTNESS_PATH := /sys/class/leds/lcd-backlight/brightness
TW_CUSTOM_BATTERY_PATH := /sys/class/power_supply/bq27x41

# hdx old bootloader dtb compatibility fix + bootloader signature exploit patch
BOARD_CUSTOM_BOOTIMG_MK := device/amazon/hdx-common/mkboot.mk

# SELinux policies
# qcom sepolicy
include device/qcom/sepolicy/sepolicy.mk

BOARD_SEPOLICY_DIRS += \
        device/amazon/hdx-common/sepolicy

