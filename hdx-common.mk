$(call inherit-product, $(SRC_TARGET_DIR)/product/languages_full.mk)

## Get non-open-source specific aspects
$(call inherit-product-if-exists, vendor/amazon/hdx-common/hdx-common-vendor.mk)

## overlays
DEVICE_PACKAGE_OVERLAYS += device/amazon/hdx-common/overlay

# Device uses high-density artwork where available
PRODUCT_AAPT_CONFIG := normal hdpi xhdpi xxhdpi
PRODUCT_AAPT_PREF_CONFIG := xxhdpi

# Audio configuration
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.audio.low_latency.xml:system/etc/permissions/android.hardware.audio.low_latency.xml

# Ramdisk
PRODUCT_PACKAGES += \
    fstab.qcom \
    init.qcom.rc \
    init.qcom.usb.rc \
    init.target.rc \
    ueventd.qcom.rc

# NFC packages
PRODUCT_PACKAGES += \
    libnfc-nci \
    libnfc_nci_jni \
    nfc_nci.msm8974 \
    NfcNci \
    Tag \
    com.android.nfc_extras

# Set default USB interface
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
    persist.sys.usb.config=mtp

# Lights
PRODUCT_PACKAGES += lights.msm8974

# QRNGD
PRODUCT_PACKAGES += qrngd

# call dalvik heap config
$(call inherit-product, frameworks/native/build/phone-xxhdpi-2048-dalvik-heap.mk)

# call hwui memory config
$(call inherit-product-if-exists, frameworks/native/build/phone-xxhdpi-2048-hwui-memory.mk)
