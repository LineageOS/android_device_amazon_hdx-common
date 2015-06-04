LOCAL_PATH := $(call my-dir)

ifneq ($(filter apollo thor,$(TARGET_DEVICE)),)

ifneq ($(TARGET_SIMULATOR),true)
include $(call first-makefiles-under,$(LOCAL_PATH))

include $(CLEAR_VARS)

FIRMWARE_DXHDCP2_IMAGES := \
    dxhdcp2.b00 dxhdcp2.b01 dxhdcp2.b02 dxhdcp2.b03 dxhdcp2.mdt
FIRMWARE_DXHDCP2_SYMLINKS := $(addprefix $(TARGET_OUT_ETC)/firmware/,$(notdir $(FIRMWARE_DXHDCP2_IMAGES)))
$(FIRMWARE_DXHDCP2_SYMLINKS): $(LOCAL_INSTALLED_MODULE)
	@echo "DXHDCP2 Firmware link: $@"
	@mkdir -p $(dir $@)
	@rm -rf $@
	$(hide) ln -sf /firmware/image/$(notdir $@) $@
ALL_DEFAULT_INSTALLED_MODULES += $(FIRMWARE_DXHDCP2_SYMLINKS)

endif

endif
