# PXE-to-Live Atomic: PXE boot directly into a running Atomic Host
# https://fedoraproject.org/wiki/Changes/AtomicHost

lang en_US.UTF-8
keyboard us
timezone America/New_York
zerombr
clearpart --all --initlabel
rootpw --lock --iscrypted locked
user --name=none
bootloader --timeout=1
network --bootproto=dhcp --device=link --activate
# We are only able to install atomic with separate /boot partition currently
part / --fstype="ext4" --size=6000
part /boot --size=500 --fstype="ext4"
shutdown
services --disabled=docker-storage-setup,network
services --enabled=NetworkManager,sshd,cloud-init,cloud-init-local,cloud-config,cloud-final
 
ostreesetup --nogpg --osname=fedora-atomic --remote=fedora-atomic --url=http://kojipkgs.fedoraproject.org/mash/atomic/22/ --ref=fedora-atomic/f22/x86_64/docker-host
 
%post

# Ensure the root password is locked, we use cloud-init
passwd -l root
userdel -r none

# We copy content of separate /boot partition to root part when building live squashfs image,
# and we don't want systemd to try to mount it when pxe booting
cat /dev/null > /etc/fstab
%end
