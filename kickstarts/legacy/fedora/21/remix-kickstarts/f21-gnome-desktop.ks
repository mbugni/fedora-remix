## f21-gnome-desktop.ks

%include f21-base-desktop.ks

%packages

# Unwanted stuff
-abrt*
-at-*
-caribou*
-deja-dup*
-orca*
-gnome-initial*

NetworkManager-l2tp
NetworkManager-openvpn-gnome
NetworkManager-pptp-gnome
control-center
dconf-editor
eog
evince
evince-nautilus
file-roller
file-roller-nautilus
gdm
gedit
gnome-bluetooth
gnome-calculator
gnome-classic-session
gnome-color-manager
gnome-disk-utility
gnome-font-viewer
gnome-initial-setup
gnome-logs
gnome-packagekit
gnome-screenshot
gnome-session-xsession
gnome-shell
gnome-software
gnome-terminal
gnome-tweak-tool
gnome-user-docs
gucharmap
gvfs-archive
gvfs-fuse
gvfs-gphoto2
gvfs-smb
metacity
mousetweaks
nm-connection-editor
sushi
xdg-user-dirs-gtk

# Internet
firefox
thunderbird  

# Tools
gparted

%end

%post
cat >> /etc/rc.d/init.d/livesys << EOF


# disable updates plugin
cat >> /usr/share/glib-2.0/schemas/org.gnome.software.gschema.override << FOE
[org.gnome.software]
download-updates=false
FOE

# don't run gnome-initial-setup
mkdir ~liveuser/.config
touch ~liveuser/.config/gnome-initial-setup-done

# make the installer show up
if [ -f /usr/share/applications/liveinst.desktop ]; then
  # Show harddisk install in shell dash
  sed -i -e 's/NoDisplay=true/NoDisplay=false/' /usr/share/applications/liveinst.desktop ""
  # need to move it to anaconda.desktop to make shell happy
  mv /usr/share/applications/liveinst.desktop /usr/share/applications/anaconda.desktop

  cat >> /usr/share/glib-2.0/schemas/org.gnome.shell.gschema.override << FOE
[org.gnome.shell]
favorite-apps=['firefox.desktop', 'gnome-terminal.desktop', 'org.gnome.Nautilus.desktop', 'anaconda.desktop']
FOE

  # Make the welcome screen show up
  if [ -f /usr/share/anaconda/gnome/fedora-welcome.desktop ]; then
    mkdir -p ~liveuser/.config/autostart
    cp /usr/share/anaconda/gnome/fedora-welcome.desktop /usr/share/applications/
    cp /usr/share/anaconda/gnome/fedora-welcome.desktop ~liveuser/.config/autostart/
  fi
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


%post

echo ""
echo "******************"
echo "POST GNOME DESKTOP"
echo "******************"

# override default Gnome settings
cat >> /usr/share/glib-2.0/schemas/fedora.remix.gschema.override << OVERRIDE_EOF
[org.gnome.desktop.input-sources]
sources=[('xkb', 'it')]

[org.gnome.shell]
favorite-apps=['gnome-tweak-tool.desktop', 'firefox.desktop', 'org.gnome.Nautilus.desktop', 'gnome-terminal.desktop']

[org.gnome.software]
download-updates=false

[org.gnome.system.locale]
region='it_IT.utf8'
OVERRIDE_EOF

glib-compile-schemas /usr/share/glib-2.0/schemas

%end
