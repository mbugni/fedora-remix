%include fedora-arm-base.ks
%include fedora-arm-xbase.ks
%include fedora-kde-packages.ks

part / --size=5000 --fstype ext4

%post
echo -n "Enabling initial-setup gui mode on startup"
ln -s /usr/lib/systemd/system/initial-setup-graphical.service /etc/systemd/system/graphical.target.wants/initial-setup-graphical.service
echo .

%end
