bootloader --location=none
part /boot/uboot --size=20 --fstype vfat
part swap --size=512 --fstype swap
part / --grow --size=6500 --fstype ext4

