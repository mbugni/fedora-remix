lang en_US.UTF-8
#keyboard us
auth --useshadow --enablemd5
selinux --enforcing
firewall --enabled --service=mdns,ssh

# make sure that initial-setup runs and lets us do all the configuration bits
firstboot --reconfig

services --enabled=ssh,NetworkManager,avahi-daemon,rsyslog,chronyd --disabled=network

#repo --name=rawhide --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=rawhide&arch=$basearch
repo --name=fedora --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=fedora-$releasever&arch=$basearch
repo --name=updates --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=updates-released-f$releasever&arch=$basearch
#repo --name=updates-testing --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=updates-testing-f$releasever&arch=$basearch

%packages
@core
@standard
@hardware-support
@dial-up

kernel
kernel-lpae
kernel-tegra

chrony
arm-boot-config
initial-setup

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
%end

