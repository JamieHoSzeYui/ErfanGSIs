if [ "$vndk" == 28 ]; then
    mount -o bind /system/bin/wpa_supplicant /vendor/bin/hw/wpa_supplicant || true
fi
mount -o bind /mnt/phh/empty_dir /vendor/overlay || true

if [[ $(cat /vendor/build.prop | grep rosy) ]]; then
    wm size 1080x2160
    wm density 480
fi
