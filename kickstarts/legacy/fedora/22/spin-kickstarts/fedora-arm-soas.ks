%include fedora-arm-base.ks
%include fedora-arm-xbase.ks
%include fedora-soas-packages.ks

%post
echo -n "Enabling initial-setup gui mode on startup"
ln -s /usr/lib/systemd/system/initial-setup-graphical.service /etc/systemd/system/graphical.target.wants/initial-setup-graphical.service
echo .

%end
