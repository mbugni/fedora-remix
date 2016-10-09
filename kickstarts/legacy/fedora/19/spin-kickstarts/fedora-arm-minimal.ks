%include fedora-arm-base.ks
%include fedora-arm-partitioning.ks

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

