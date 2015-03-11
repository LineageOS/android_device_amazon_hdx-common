# use manually appened kernel+dtb
ifeq ($(TARGET_KERNEL_CONFIG),apollo-cyanogenmod_defconfig)
DTS_NAME := apollo-v2
endif
ifeq ($(TARGET_KERNEL_CONFIG),thor-cyanogenmod_defconfig)
DTS_NAME := thor-v2
endif

# Hacked boot image
$(INSTALLED_BOOTIMAGE_TARGET): $(MKBOOTIMG) $(INTERNAL_BOOTIMAGE_FILES)
	@echo -e ${CL_CYN}"Building hdx hacked boot image: $@"${CL_RST}
	$(KERNEL_OUT)/scripts/dtc/dtc -p 2048 -O dtb -o $(KERNEL_OUT)/arch/arm/boot/$(DTS_NAME).dtb \
		$(TARGET_KERNEL_SOURCE)/arch/arm/boot/dts/$(DTS_NAME).dts
	cat $(KERNEL_OUT)/arch/arm/boot/zImage $(KERNEL_OUT)/arch/arm/boot/$(DTS_NAME).dtb > $(PRODUCT_OUT)/kernel
	$(MKBOOTIMG) $(INTERNAL_BOOTIMAGE_ARGS) $(BOARD_MKBOOTIMG_ARGS) --output $@
	cd ./device/amazon/hdx-common/Cuber/ && \
	make Cuber-boot && \
	./Cuber-boot --sign $@ $@.signed && \
	cd -
	$(hide) mv $@.signed $@
	$(hide) $(call assert-max-image-size,$@,$(BOARD_BOOTIMAGE_PARTITION_SIZE),raw)
	@echo -e ${CL_CYN}"Made hdx hacked boot image: $@"${CL_RST}

# Hacked recovery image
$(INSTALLED_RECOVERYIMAGE_TARGET): $(MKBOOTIMG) $(recovery_ramdisk) $(recovery_kernel)
	@echo -e ${CL_CYN}"Building hdx hacked recovery image: $@"${CL_RST}
	$(KERNEL_OUT)/scripts/dtc/dtc -p 2048 -O dtb -o $(KERNEL_OUT)/arch/arm/boot/$(DTS_NAME).dtb \
		$(TARGET_KERNEL_SOURCE)/arch/arm/boot/dts/$(DTS_NAME).dts
	cat $(KERNEL_OUT)/arch/arm/boot/zImage $(KERNEL_OUT)/arch/arm/boot/$(DTS_NAME).dtb > $(PRODUCT_OUT)/kernel
	$(hide) $(MKBOOTIMG) $(INTERNAL_RECOVERYIMAGE_ARGS) $(BOARD_MKBOOTIMG_ARGS) --output $@
	cd ./device/amazon/hdx-common/Cuber/ && \
	make Cuber-recovery && \
	./Cuber-recovery --sign $@ $@.signed && \
	cd -
	$(hide) mv $@.signed $@
	$(hide) $(call assert-max-image-size,$@,$(BOARD_RECOVERYIMAGE_PARTITION_SIZE),raw)
	@echo -e ${CL_CYN}"Made hdx hacked recovery image: $@"${CL_RST}
