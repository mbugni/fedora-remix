%include fedora-arm-base.ks

part /boot --size=300 --fstype ext3
part swap --size=256 --fstype swap
part / --size=1200 --fstype ext4

%packages
-@standard
-@dial-up
-initial-setup-gui
-generic-release*
%end

%post

# setup systemd to boot to the right runlevel
echo -n "Setting default runlevel to multiuser text mode"
rm -f /etc/systemd/system/default.target
ln -s /lib/systemd/system/multi-user.target /etc/systemd/system/default.target
echo .

echo -n "Enabling initial-setup text mode on startup"
ln -s /usr/lib/systemd/system/initial-setup-text.service /etc/systemd/system/multi-user.target.wants/initial-setup-text.service
echo .

%end

