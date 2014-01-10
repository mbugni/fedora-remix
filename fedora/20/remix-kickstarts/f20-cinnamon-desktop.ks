## f20-cinnamon-desktop.ks

%include f20-base-desktop.ks

%packages

# Unwanted stuff
-abrt*
-at-*
-caribou*
-deja-dup*
-orca*
-system-config-users

NetworkManager-*vpn*
PackageKit-gtk*
cinnamon
dconf-editor
eog
evince
file-roller
gcalctool
gedit
gnome-disk-utility
gnome-font-viewer
gnome-icon-theme
gnome-icon-theme-legacy
gnome-icon-theme-symbolic
gnome-packagekit
gnome-screenshot
gnome-terminal
gucharmap
gvfs-archive
gvfs-fuse
gvfs-gphoto2
gvfs-smb
libgnomeui
libproxy-mozjs
lightdm
lightdm-gtk
metacity
nemo-fileroller
network-manager-applet
nm-connection-editor
xdg-user-dirs-gtk

# Internet
firefox
thunderbird  

# Tools
gparted

# FIXME; apparently the glibc maintainers dislike this, but it got put into the
# desktop image at some point.  We won't touch this one for now.
nss-mdns

# This one needs to be kicked out of @standard
-smartmontools

%end

%post
cat >> /etc/rc.d/init.d/livesys << EOF


# disable updates plugin
cat >> /usr/share/glib-2.0/schemas/org.gnome.settings-daemon.plugins.updates.gschema.override << FOE
[org.gnome.settings-daemon.plugins.updates]
active=false
FOE

# make the installer show up
if [ -f /usr/share/applications/liveinst.desktop ]; then
  # Show harddisk install in shell dash
  sed -i -e 's/NoDisplay=true/NoDisplay=false/' /usr/share/applications/liveinst.desktop ""
  mkdir ~liveuser/Desktop
  cp /usr/share/applications/liveinst.desktop ~liveuser/Desktop/
  chmod +x ~liveuser/Desktop/liveinst.desktop

  cat > /usr/share/glib-2.0/schemas/org.cinnamon.remix.gschema.override << FOE
[org.cinnamon]
favorite-apps=['cinnamon-settings.desktop', 'firefox.desktop', 'nemo.desktop', 'gnome-terminal.desktop', 'anaconda.desktop']
FOE
fi

# rebuild schema cache with any overrides we installed
glib-compile-schemas /usr/share/glib-2.0/schemas

# set up auto-login
cat > /etc/gdm/custom.conf << FOE
[daemon]
AutomaticLoginEnable=True
AutomaticLogin=liveuser
FOE

# Turn off PackageKit-command-not-found while uninstalled
if [ -f /etc/PackageKit/CommandNotFound.conf ]; then
  sed -i -e 's/^SoftwareSourceSearch=true/SoftwareSourceSearch=false/' /etc/PackageKit/CommandNotFound.conf
fi

# make sure to set the right permissions and selinux contexts
chown -R liveuser:liveuser /home/liveuser/
restorecon -R /home/liveuser/

EOF

%end


## REMIX cinnamon

%post

echo ""
echo "*********************"
echo "POST CINNAMON DESKTOP"
echo "*********************"

# set up lightdm autologin
sed -i 's/^#autologin-user=.*/autologin-user=liveuser/' /etc/lightdm/lightdm.conf
sed -i 's/^#autologin-user-timeout=.*/autologin-user-timeout=0/' /etc/lightdm/lightdm.conf

# set Cinnamon as default session, otherwise login will fail
sed -i 's/^#user-session=.*/user-session=cinnamon/' /etc/lightdm/lightdm.conf

# override default Cinnamon settings
cat >> /usr/share/glib-2.0/schemas/fedora.remix.gschema.override << OVERRIDE_EOF
[org.gnome.desktop.interface]
font-name='Sans 10'
document-font-name='Sans 10'
monospace-font-name='Monospace 10'

[org.cinnamon.desktop.interface]
font-name='Sans 10'
gtk-theme='Adwaita'

[org.cinnamon.desktop.wm.preferences]
theme='Adwaita'
titlebar-font='Sans Bold 9'

[org.gnome.settings-daemon.plugins.updates]
active=false
auto-download-updates=false
frequency-get-updates=0
frequency-get-upgrades=0

[org.cinnamon]
favorite-apps=['cinnamon-settings.desktop', 'firefox.desktop', 'nemo.desktop', 'gnome-terminal.desktop']
OVERRIDE_EOF

glib-compile-schemas /usr/share/glib-2.0/schemas

%end
