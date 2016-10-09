lang en_US.UTF-8
#keyboard us
auth --useshadow --passalgo=sha512
selinux --enforcing
firewall --enabled --service=mdns,ssh

# configure extlinux bootloader
bootloader extlinux

part /boot --size=512 --fstype ext4
part swap --size=512 --fstype swap
part / --size=3000 --fstype ext4

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

dracut-config-generic

chrony
arm-boot-config
extlinux-bootloader
initial-setup
initial-setup-gui
#lets resize / on first boot
# dracut-modules-growroot

# remove this in %post
dracut-config-generic

# install uboot images
uboot-images-armv7

%end

%post

# work around for poor key import UI in PackageKit
rm -f /var/lib/rpm/__db*
releasever=$(rpm -q --qf '%{version}\n' fedora-release)
basearch=armhfp
rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-fedora-$releasever-$basearch
echo "Packages within this ARM disk image"
rpm -qa
# Note that running rpm recreates the rpm db files which aren't needed or wanted
rm -f /var/lib/rpm/__db*

# Because memory is scarce resource in most arm systems we are differing from the Fedora
# default of having /tmp on tmpfs.
echo "Disabling tmpfs for /tmp."
systemctl mask tmp.mount

/usr/sbin/a-b-c

yum -y remove dracut-config-generic

%end

