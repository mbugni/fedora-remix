%include fedora-arm-base.ks
%include fedora-arm-xbase.ks
%include fedora-desktop-packages.ks
%include fedora-arm-partitioning.ks

part / --size=4000 --fstype ext4

%packages
-initial-setup

%end

