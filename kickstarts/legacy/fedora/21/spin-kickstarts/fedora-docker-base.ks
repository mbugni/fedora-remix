# This is a minimal Fedora install designed to serve as a Docker base image. 
#
# To keep this image minimal it only installs English language. You need to change
# yum configuration in order to enable other languages.

cmdline
bootloader --location=none
timezone America/New_York --isUtc --nontp
rootpw --plaintext qweqwe

keyboard us
firewall --disable
zerombr
clearpart --all
part / --size 3000 --fstype ext4
network --bootproto=dhcp --device=link --activate --onboot=on
reboot

%packages --excludedocs --instLangs=en --nocore
bash
fedora-release
vim-minimal
yum
#fakesystemd #TODO: waiting for review https://bugzilla.redhat.com/show_bug.cgi?id=1118740
-kernel


%end

%post --log=/tmp/anaconda-post.log
# Set the language rpm nodocs transaction flag persistently in the
# image yum.conf and rpm macros

LANG="en_US"
echo "%_install_lang $LANG" > /etc/rpm/macros.image-language-conf

awk '(NF==0&&!done){print "override_install_langs='$LANG'\ntsflags=nodocs";done=1}{print}' \
    < /etc/yum.conf > /etc/yum.conf.new
mv /etc/yum.conf.new /etc/yum.conf

echo "Import RPM GPG key"
releasever=$(rpm -q --qf '%{version}\n' fedora-release)
basearch=$(uname -i)
rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-fedora-$releasever-$basearch

rm -f /usr/lib/locale/locale-archive
rm -rf /var/cache/yum/*
rm -f /tmp/ks-script*

%end
