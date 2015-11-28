%include fedora-arm-base.ks
%include fedora-arm-xbase.ks
%include fedora-workstation-packages.ks

part / --size=5000 --fstype ext4

%packages
-initial-setup
-initial-setup-gui

%end

