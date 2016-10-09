%include fedora-arm-base.ks

# server defaults to xfs for / so lets do so on arm also
part / --size=3000 --fstype xfs

%packages
-@dial-up
# install the default groups for the server evironment since installing the environment is not working
@server-product
@standard
@headless-management
@container-management
@domain-client
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

