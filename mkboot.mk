# use manually appened kernel+dtb
ifeq ($(TARGET_KERNEL_CONFIG),apollo-cyanogenmod_defconfig)
DTS_NAMES := apollo
endif
ifeq ($(TARGET_KERNEL_CONFIG),thor-cyanogenmod_defconfig)
DTS_NAMES := thor
endif

DTS_FILES = $(wildcard $(TOP)/$(TARGET_KERNEL_SOURCE)/arch/arm/boot/dts/$(DTS_NAME)*.dts)
DTS_FILE = $(lastword $(subst /, ,$(1)))
DTB_FILE = $(addprefix $(KERNEL_OUT)/arch/arm/boot/,$(patsubst %.dts,%.dtb,$(call DTS_FILE,$(1))))
ZIMG_FILE = $(addprefix $(KERNEL_OUT)/arch/arm/boot/,$(patsubst %.dts,%-zImage,$(call DTS_FILE,$(1))))
KERNEL_ZIMG = $(KERNEL_OUT)/arch/arm/boot/zImage
DTC = $(KERNEL_OUT)/scripts/dtc/dtc

define append-dtb
mkdir -p $(KERNEL_OUT)/arch/arm/boot;\
rm -f $(KERNEL_OUT)/arch/arm/boot/*.dtb;\
rm -f $(KERNEL_OUT)/arch/arm/boot/*.dtb_dts;\
$(foreach DTS_NAME, $(DTS_NAMES), \
   $(foreach d, $(DTS_FILES), \
      $(DTC) -p 2048 -O dtb -o $(call DTB_FILE,$(d)) $(d); \
      $(DTC) -p 2048 -O dts -o $(call DTB_FILE,$(d))_dts $(d); \
      cat $(KERNEL_ZIMG) $(call DTB_FILE,$(d)) > $(call ZIMG_FILE,$(d));))
endef

# Hacked boot image
$(INSTALLED_BOOTIMAGE_TARGET): $(MKBOOTIMG) $(INTERNAL_BOOTIMAGE_FILES)
	@echo -e ${CL_CYN}"Building hdx hacked boot image: $@"${CL_RST}
	$(append-dtb)
	cp $(KERNEL_OUT)/arch/arm/boot/$(DTS_NAMES)-v2-zImage $(PRODUCT_OUT)/kernel
	$(MKBOOTIMG) $(INTERNAL_BOOTIMAGE_ARGS) $(BOARD_MKBOOTIMG_ARGS) --output $@
	./device/amazon/hdx-common/Cuber/Cuber -sign $@ $@.signed
	$(hide) mv $@.signed $@
	$(hide) $(call assert-max-image-size,$@,$(BOARD_BOOTIMAGE_PARTITION_SIZE),raw)
	@echo -e ${CL_CYN}"Made hdx hacked boot image: $@"${CL_RST}

# Hacked recovery image
$(INSTALLED_RECOVERYIMAGE_TARGET): $(MKBOOTIMG) $(recovery_ramdisk) $(recovery_kernel)
	@echo -e ${CL_CYN}"Building hdx hacked recovery image: $@"${CL_RST}
	$(append-dtb)
	cp $(KERNEL_OUT)/arch/arm/boot/$(DTS_NAMES)-v2-zImage $(PRODUCT_OUT)/kernel
	$(hide) $(MKBOOTIMG) $(INTERNAL_RECOVERYIMAGE_ARGS) $(BOARD_MKBOOTIMG_ARGS) --output $@
	./device/amazon/hdx-common/Cuber/Cuber -sign $@ $@.signed
	$(hide) mv $@.signed $@
	$(hide) $(call assert-max-image-size,$@,$(BOARD_RECOVERYIMAGE_PARTITION_SIZE),raw)
	@echo -e ${CL_CYN}"Made hdx hacked recovery image: $@"${CL_RST}
