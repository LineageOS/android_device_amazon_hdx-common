LOCAL_PATH := $(call my-dir)

ifneq ($(filter apollo thor,$(TARGET_DEVICE)),)

ifneq ($(TARGET_SIMULATOR),true)
include $(call first-makefiles-under,$(LOCAL_PATH))
endif

endif
