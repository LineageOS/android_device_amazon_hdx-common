COMMON_FOLDER := device/amazon/hdx-common

$(call inherit-product, $(SRC_TARGET_DIR)/product/languages_full.mk)

# Get non-open-source specific aspects
$(call inherit-product-if-exists, vendor/amazon/hdx-common/hdx-common-vendor.mk)

# AOSP overlay
DEVICE_PACKAGE_OVERLAYS += $(COMMON_FOLDER)/overlay-common

# Device uses high-density artwork where available
PRODUCT_AAPT_CONFIG := normal hdpi xhdpi xxhdpi
PRODUCT_AAPT_PREF_CONFIG := xxhdpi

# Permissions
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/tablet_core_hardware.xml:system/etc/permissions/tablet_core_hardware.xml \
    frameworks/native/data/etc/android.hardware.audio.low_latency.xml:system/etc/permissions/android.hardware.audio.low_latency.xml \
    frameworks/native/data/etc/android.hardware.camera.flash-autofocus.xml:system/etc/permissions/android.hardware.camera.flash-autofocus.xml \
    frameworks/native/data/etc/android.hardware.camera.front.xml:system/etc/permissions/android.hardware.camera.front.xml \
    frameworks/native/data/etc/android.hardware.location.gps.xml:system/etc/permissions/android.hardware.location.gps.xml \
    frameworks/native/data/etc/android.hardware.wifi.xml:system/etc/permissions/android.hardware.wifi.xml \
    frameworks/native/data/etc/android.hardware.wifi.direct.xml:system/etc/permissions/android.hardware.wifi.direct.xml \
    frameworks/native/data/etc/android.hardware.sensor.accelerometer.xml:system/etc/permissions/android.hardware.sensor.accelerometer.xml \
    frameworks/native/data/etc/android.hardware.sensor.compass.xml:system/etc/permissions/android.hardware.compass.xml \
    frameworks/native/data/etc/android.hardware.sensor.light.xml:system/etc/permissions/android.hardware.sensor.light.xml \
    frameworks/native/data/etc/android.hardware.sensor.gyroscope.xml:system/etc/permissions/android.hardware.sensor.gyroscope.xml \
    frameworks/native/data/etc/android.hardware.sensor.proximity.xml:system/etc/permissions/android.hardware.sensor.proximity.xml \
    frameworks/native/data/etc/android.hardware.sensor.stepcounter.xml:system/etc/permissions/android.hardware.sensor.stepcounter.xml \
    frameworks/native/data/etc/android.hardware.sensor.stepdetector.xml:system/etc/permissions/android.hardware.sensor.stepdetector.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.multitouch.jazzhand.xml:system/etc/permissions/android.hardware.touchscreen.multitouch.jazzhand.xml \
    frameworks/native/data/etc/android.hardware.usb.accessory.xml:system/etc/permissions/android.hardware.usb.accessory.xml \
    frameworks/native/data/etc/android.hardware.usb.host.xml:system/etc/permissions/android.hardware.usb.host.xml \
    frameworks/native/data/etc/android.software.sip.voip.xml:system/etc/permissions/android.software.sip.voip.xml \
    frameworks/native/data/etc/android.hardware.telephony.gsm.xml:system/etc/permissions/android.hardware.telephony.gsm.xml \
    frameworks/native/data/etc/android.hardware.bluetooth_le.xml:system/etc/permissions/android.hardware.bluetooth_le.xml

# Ramdisk
PRODUCT_PACKAGES += \
	fstab.qcom \
	init.qcom.rc \
	init.qcom.usb.rc \
	init.target.rc \
	init.class_main.sh \
	init.mdm.sh \
	init.qcom.class_core.sh \
	init.qcom.early_boot.sh \
	init.qcom.factory.sh \
	init.qcom.sensor.sh \
	init.qcom.sh \
	init.qcom.ssr.sh \
	init.qcom.syspart_fixup.sh \
	init.qcom.usb.sh \
	ueventd.qcom.rc \
	init.recovery.qcom.rc

# fix libqc-opt.so (missing "utext_openUChars_51" import from stagefright 4.X)
# https://github.com/TheMuppets/proprietary_vendor_samsung/blob/cm-12.0/d2-common/proprietary/lib/libqc-opt.so
PRODUCT_COPY_FILES += \
	$(COMMON_FOLDER)/overlay-binaries/libqc-opt.so:system/vendor/lib/libqc-opt.so

# Media
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/audio_policy.conf:system/etc/audio_policy.conf \
    $(LOCAL_PATH)/configs/media_profiles.xml:system/etc/media_profiles.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_audio.xml:system/etc/media_codecs_google_audio.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_video.xml:system/etc/media_codecs_google_video.xml \
    frameworks/av/media/libstagefright/data/media_codecs_ffmpeg.xml:system/etc/media_codecs_ffmpeg.xml \
    $(LOCAL_PATH)/configs/media_codecs.xml:system/etc/media_codecs.xml
 #   $(LOCAL_PATH)/configs/mixer_paths.xml:system/etc/mixer_paths.xml

# Audio
PRODUCT_PACKAGES += \
    audio.a2dp.default \
    audio_policy.msm8974 \
    audio.primary.msm8974 \
    audio.r_submix.default \
    audio.usb.default \
    libaudio-resampler \
    libqcompostprocbundle \
    libqcomvisualizer \
    libqcomvoiceprocessing

PRODUCT_COPY_FILES += \
        $(LOCAL_PATH)/configs/audio_effects.conf:system/vendor/etc/audio_effects.conf

# Charger
PRODUCT_PACKAGES += \
    charger \
    charger_res_images

# Filesystem management tools
PRODUCT_PACKAGES += \
    make_ext4fs \
    e2fsck \
    setup_fs

PRODUCT_PACKAGES += \
 	libxml2 \
	libnetcmdiface

# Graphics
PRODUCT_PACKAGES += \
    copybit.msm8974 \
    gralloc.msm8974 \
    hwcomposer.msm8974 \
    memtrack.msm8974 \
    liboverlay \
    libqdutils \
    libqservice \
    libqdMetaData

# GPS
PRODUCT_PACKAGES += \
    gps.msm8974

# Lights
PRODUCT_PACKAGES += \
    lights.msm8974

# Media
PRODUCT_PACKAGES += \
    libc2dcolorconvert \
    libdivxdrmdecrypt \
    libdashplayer \
    libOmxAacEnc \
    libOmxAmrEnc \
    libOmxCore \
    libOmxEvrcEnc \
    libOmxQcelp13Enc \
    libOmxVdec \
    libOmxVdecHevc \
    libOmxVenc \
    libstagefrighthw \
    qcmediaplayer

# Power
PRODUCT_PACKAGES += \
    power.msm8974

# QRNGD
PRODUCT_PACKAGES += \
    qrngd \
    qrngp

# Keystore
#PRODUCT_PACKAGES += \
#    keystore.msm8974

# USB
PRODUCT_PACKAGES += \
    com.android.future.usb.accessory

PRODUCT_PACKAGES += \
	wpa_supplicant \
    wpa_supplicant_overlay.conf \
    p2p_supplicant_overlay.conf \
    hostapd_default.conf \
    hostapd.accept \
    hostapd.deny
#   wcnss_service <- not working

# BT
PRODUCT_PACKAGES += \
	libbt-vendor

PRODUCT_BOOT_JARS += qcmediaplayer

# Wifi
#PRODUCT_PACKAGES += \
#    libnetcmdiface \
#    macloader \
#    crda \
#    regulatory.bin \
#    linville.key.pub.pem

# QC Perf
PRODUCT_PROPERTY_OVERRIDES += \
    ro.vendor.extension_library=/vendor/lib/libqc-opt.so

# Common build.props
PRODUCT_PROPERTY_OVERRIDES += \
    ro.chipname=msm8974 \
    ro.sf.lcd_density=320 \
    ro.opengles.version=196608 \
    persist.timed.enable=true \
    keyguard.no_require_sim=true \
    lockscreen.rot_override=true

# Radio props
PRODUCT_PROPERTY_OVERRIDES += \
    rild.libpath=/system/lib/libril-lab126qmi.so \
    ril.subscription.types=NV,RUIM \
    persist.rild.nitz_plmn="" \
    persist.rild.nitz_long_ons_0="" \
    persist.rild.nitz_long_ons_1="" \
    persist.rild.nitz_long_ons_2="" \
    persist.rild.nitz_long_ons_3="" \
    persist.rild.nitz_short_ons_0="" \
    persist.rild.nitz_short_ons_1="" \
    persist.rild.nitz_short_ons_2="" \
    persist.rild.nitz_short_ons_3="" \
    DEVICE_PROVISIONED=1 \
    ro.telephony.default_network=9

PRODUCT_PROPERTY_OVERRIDES += \
	debug.sf.hw=1 \
	debug.egl.hw=1 \
	persist.hwc.mdpcomp.enable=true \
	debug.mdpcomp.logs=0 

# new props test
PRODUCT_PROPERTY_OVERRIDES += \
	debug.composition.type=c2d \
	sys.hwc.gpu_perf_mode=1 \
	dev.pm.dyn_samplingrate=1 \
	persist.demo.hdmirotationlock=false \
	ro.hdmi.enable=true \
	ro.use_data_netmgrd=true \
	persist.data.netmgrd.qos.enable=true \
	ro.data.large_tcp_window_size=true \
	persist.timed.enable=true \
	ro.qualcomm.cabl=1 \
	telephony.lteOnCdmaDevice=0 \
	persist.fuse_sdcard=true \
	ro.qc.sdk.sensors.gestures=true \
	ro.qc.sdk.gestures.camera=false \
	ro.qc.sdk.camera.facialproc=false \
	ro.qcom.ad=1 \
	ro.qcom.ad.calib.data=/system/etc/ad_calib.cfg \
	persist.debug.wfd.enable=1 \
	persist.sys.wfd.virtual=0 \
	ro.usb.vid=1949 \
	ro.usb.pid=000c \
	persist.sys.usb.config=mtp,adb \
	com.msm_enhancement=true \
	ro.wifi.standby.dtim=3 \
	ro.recovery.wl.maxstore=524288 \
	ro.ril.usb.port.serial=ttyUSB \
	ro.ril.usb.port.qmi=qmi_usb \
	ro.ril.usb.port.rmnet=rmnet_usb \
	telephony.sms.receive=true \
	keyguard.ori.timeout=350

# audio/media props
PRODUCT_PROPERTY_OVERRIDES += \
	persist.audio.calfile0=/etc/acdbdata/THOR/Bluetooth_cal.acdb \
	persist.audio.calfile1=/etc/acdbdata/THOR/General_cal.acdb \
	persist.audio.calfile2=/etc/acdbdata/THOR/Global_cal.acdb \
	persist.audio.calfile3=/etc/acdbdata/THOR/Handset_cal.acdb \
	persist.audio.calfile4=/etc/acdbdata/THOR/Hdmi_cal.acdb \
	persist.audio.calfile5=/etc/acdbdata/THOR/Headset_cal.acdb \
	persist.audio.calfile6=/etc/acdbdata/THOR/Speaker_cal.acdb \
	media.aac_51_output_enabled=true \
	vidc.debug.level=1 \
	persist.audio.fluence.voicecall=true \
	audio.offload.buffer.size.kb=32 \
	av.offload.enable=true


PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0

# We have enough storage space to hold precise GC data
PRODUCT_TAGS += dalvik.gc.type-precise

# call dalvik heap config
$(call inherit-product, frameworks/native/build/phone-xxhdpi-2048-dalvik-heap.mk)

# call hwui memory config
$(call inherit-product-if-exists, frameworks/native/build/phone-xxhdpi-2048-hwui-memory.mk)

