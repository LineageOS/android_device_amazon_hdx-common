# Copyright (c) 2011-2013, The Linux Foundation. All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above
#       copyright notice, this list of conditions and the following
#       disclaimer in the documentation and/or other materials provided
#       with the distribution.
#     * Neither the name of The Linux Foundation nor the names of its
#       contributors may be used to endorse or promote products derived
#       from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESS OR IMPLIED
# WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT
# ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS
# BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
# BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
# OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
# IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
#

on early-init
    mkdir /firmware 0771 system system
    symlink /data/tombstones /tombstones
    setprop ro.sf.lcd_density 320
    chown system system /sys/devices/virtual/graphics/fb0/ad
    chown system system /sys/devices/virtual/graphics/fb1/ad

on init
    # Set the property to indicate type of virtual display to 0
    # 0 indicates that virtual display is not a Wifi display and that the
    # session is not exercised through RemoteDisplay in the android framework
    setprop persist.sys.wfd.virtual 0


# import cne init file
on post-fs
    export LD_PRELOAD /vendor/lib/libNimsWrap.so

on fs
    # Keeping system partition out of fstab file, in order to use resize2fs to modify
    # data partition, before it gets mounted in fstab.

    #wait /dev/block/platform/msm_sdcc.1/by-name/system
    #mount ext4 /dev/block/platform/msm_sdcc.1/by-name/system /system ro barrier=1 discard

    # In order to fit different sizes of devices, the user data image needs to be created small and resized during init.
    # Cryptfs needs 16K of free space at the end of data partition to store its volume keys,
    # a custom implementation of resize2fs is used to reserve that free space.

    #wait /dev/block/platform/msm_sdcc.1/by-name/cache
    #exec /system/bin/e2fsck -y -f /dev/block/platform/msm_sdcc.1/by-name/cache
    #mount ext4 /dev/block/platform/msm_sdcc.1/by-name/cache /cache nosuid nodev barrier=1
    #exec /system/bin/sh /system/etc/resize_user_data.sh
    
    mount_all fstab.qcom

    # Keeping following partitions outside fstab file. As user may not have
    # these partition flashed on the device. Failure to mount any partition in fstab file
    # results in failure to launch late-start class.
    #mkdir /mnt/sqfs 0771 system system
    #mount squashfs loop@/system/sqfs/container.sqfs /mnt/sqfs wait ro

    wait /dev/block/platform/msm_sdcc.1/by-name/persist
    mount ext4 /dev/block/platform/msm_sdcc.1/by-name/persist /persist nosuid nodev barrier=1

    wait /dev/block/platform/msm_sdcc.1/by-name/modem
    mount vfat /dev/block/platform/msm_sdcc.1/by-name/modem /firmware ro shortname=lower,uid=1000,gid=1000,dmask=227,fmask=337,context=u:object_r:firmware_file:s0
    write /sys/kernel/boot_adsp/boot 1

on post-fs-data
    mkdir /data/tombstones 0771 system system
    mkdir /tombstones/modem 0771 system system
    mkdir /tombstones/lpass 0771 system system
    mkdir /tombstones/wcnss 0771 system system
    mkdir /tombstones/dsps 0771 system system
    mkdir /persist/sensor_calibration 0771 system system

on boot
    exec /system/bin/sh /etc/init.set_model.sh
    insmod /system/lib/modules/adsprpc.ko

# Allow usb charging to be disabled persistently
on property:persist.usb.chgdisabled=1
    write /sys/class/power_supply/battery/charging_enabled 0

on property:persist.usb.chgdisabled=0
    write /sys/class/power_supply/battery/charging_enabled 1

# bt_hsic_control
service bt_hsic_control /system/bin/sh /system/etc/hsic.control.bt.sh
    user root
    disabled

on property:bluetooth.hsic_ctrl=load_wlan
    start bt_hsic_control

on property:bluetooth.hsic_ctrl=unbind_hsic
    start bt_hsic_control

#start camera server as daemon
service qcamerasvr /system/bin/mm-qcamera-daemon
    class main
    user camera
    group camera system inet input graphics

#start gesture server as daemon
service qgesturesvr /system/bin/mm-gesture-daemon
    class late_start
    user system
    group system camera input graphics net_bt_stack

service qrngd /system/bin/qrngd -f
    class main
    user root
    group root

service qrngp /system/bin/qrngp
    class main
    user root
    group root
    oneshot
    disabled

on property:sys.boot_completed=1
    start qrngp

service qseecomd /system/bin/qseecomd
   class core
   user root
   group root

service mpdecision /system/bin/mpdecision --avg_comp
   user root
   disabled

service qosmgrd /system/bin/qosmgr /system/etc/qosmgr_rules.xml
   user system
   group system
   disabled

service thermal-engine /system/bin/thermal-engine -c /system/etc/thermal-engine-thor.conf
   class main
   user root
   group root

service security-check1 /sbin/security_boot_check system
    class core
    oneshot

service security-check2 /sbin/security_boot_check recovery
    class core
    oneshot

service time_daemon /system/bin/time_daemon
   class late_start
   user root
   group root

service adsprpcd /system/bin/adsprpcd
   class main
   user media
   group media

service audiod /system/bin/audiod
   class late_start
   user system
   group system

service usf_tester /system/bin/usf_tester
    user system
    group system inet
    disabled

service usf_epos /system/bin/usf_epos
    user system
    group system inet
    disabled

service usf_gesture /system/bin/usf_gesture
    user system
    group system inet
    disabled

service usf_p2p /system/bin/usf_p2p
    user system
    group system inet
    disabled

service usf_hovering /system/bin/usf_hovering
    user system
    group system inet
    disabled

service usf_proximity /system/bin/usf_proximity
    user system
    group system inet
    disabled

service usf-post-boot /system/bin/sh /system/etc/usf_post_boot.sh
    class late_start
    user root
    disabled
    oneshot

on property:init.svc.bootanim=stopped
    start usf-post-boot

service ath6kl-service /system/bin/ath6kl-service
    class late_start
    user root
    oneshot

service qca6234-service /system/bin/sh /system/etc/qca6234-service.sh
    class late_start
    user root
    oneshot

service wcnss-service /system/bin/wcnss_service
    class late_start
    user root
    group system wifi
    oneshot

service printemmc /system/bin/get_emmcid.sh
	class late_start
	user root
    oneshot

on property:sys.ims.QMI_DAEMON_STATUS=1
    start imsdatadaemon

on property:sys.ims.DATA_DAEMON_STATUS=1
    start ims_rtp_daemon

service check_shutdown /system/bin/auto_shutdown
    class late_start
    user root
    oneshot

service ppd /system/bin/mm-pp-daemon --enable-cabl --enable-ad
    class late_start
    user system
    socket pps stream 0660 system system graphics
    group system graphics

service panelcal /system/bin/display-pp droid_set_pcc2mdp
    class late_start
    user root
    oneshot

service trigger_prov /system/bin/sh /sbin/check_prov.sh
    class late_start
    user root
    oneshot

on property:init.svc.surfaceflinger=stopped
    stop ppd

service trigger_prov /system/bin/sh /sbin/check_prov.sh
    class late_start
    user root
    oneshot

#restart Start RIL script once disk decrypts
on property:vold.decrypt=trigger_reset_main
    start startril

#conditional start RIL for non-wifi devices
service startril /system/bin/wan_start
    class main
    oneshot

on property:wlan.driver.status=ok
    chown system system /sys/kernel/debug/ieee80211/phy0/ath6kl/dtim_ext
