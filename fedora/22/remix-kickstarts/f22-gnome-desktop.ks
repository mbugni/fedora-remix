## f22-gnome-desktop.ks

%include f22-base-desktop.ks
%include f22-gnome-packages.ks


%post

# This is a huge file and things work ok without it
rm -f /usr/share/icons/HighContrast/icon-theme.cache

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

  # Copy Anaconda branding in place
  if [ -d /usr/share/lorax/product/usr/share/anaconda ]; then
    cp -a /usr/share/lorax/product/* /
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

#[org.gnome.desktop.interface]
#document-font-name='Noto Sans 11'
#font-name='Noto Sans 11'
#monospace-font-name='Droid Sans Mono 11'

#[org.gnome.desktop.wm.preferences]
#titlebar-font='Noto Sans Bold 10'

cat >> /usr/share/glib-2.0/schemas/fedora.remix.gschema.override << OVERRIDE_EOF
[org.gnome.desktop.input-sources]
sources=[('xkb', 'it')]

[org.gnome.settings-daemon.plugins.xsettings]
antialiasing='rgba'
hinting='slight'

[org.gnome.shell]
favorite-apps=['gnome-tweak-tool.desktop', 'firefox.desktop', 'org.gnome.Nautilus.desktop', 'gnome-terminal.desktop']

[org.gnome.software]
download-updates=false

[org.gnome.system.locale]
region='it_IT.utf8'
OVERRIDE_EOF

glib-compile-schemas /usr/share/glib-2.0/schemas

%end
