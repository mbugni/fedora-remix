lang en_US.UTF-8
#keyboard us
auth --useshadow --enablemd5
selinux --enforcing
firewall --enabled --service=mdns,ssh

# configure extlinux bootloader
bootloader extlinux

# make sure that initial-setup runs and lets us do all the configuration bits
firstboot --reconfig

services --enabled=ssh,NetworkManager,avahi-daemon,rsyslog,chronyd --disabled=network

%include fedora-repo.ks

%packages
@core
@standard
@hardware-support
@dial-up

kernel
kernel-lpae

chrony
arm-boot-config
extlinux-bootloader
initial-setup
#lets resize / on first boot
dracut-modules-growroot

# remove this in %post
dracut-config-generic

# install uboot images
uboot-beagle
uboot-beaglebone
uboot-origen
uboot-panda
uboot-smdkv310
uboot-uevm
uboot-wandboard_dl
uboot-wandboard_solo
uboot-wandboard_quad

%end

%post

# Because memory is scarce resource in most arm systems we are differing from the Fedora
# default of having /tmp on tmpfs.
echo "Disabling tmpfs for /tmp."
systemctl mask tmp.mount

/usr/sbin/a-b-c

yum -y remove dracut-config-generic

%end

