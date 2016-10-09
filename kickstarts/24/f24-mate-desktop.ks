## f24-mate-desktop.ks

%include f24-base-desktop.ks
%include f24-mate-packages.ks

%post
cat >> /etc/rc.d/init.d/livesys << EOF


# make the installer show up
if [ -f /usr/share/applications/liveinst.desktop ]; then
  # Show harddisk install in shell dash
  sed -i -e 's/NoDisplay=true/NoDisplay=false/' /usr/share/applications/liveinst.desktop ""
fi
mkdir /home/liveuser/Desktop
cp /usr/share/applications/liveinst.desktop /home/liveuser/Desktop

# rebuild schema cache with any overrides we installed
glib-compile-schemas /usr/share/glib-2.0/schemas

# set up lightdm autologin
sed -i 's/^#autologin-user=.*/autologin-user=liveuser/' /etc/lightdm/lightdm.conf
sed -i 's/^#autologin-user-timeout=.*/autologin-user-timeout=0/' /etc/lightdm/lightdm.conf
#sed -i 's/^#show-language-selector=.*/show-language-selector=true/' /etc/lightdm/lightdm-gtk-greeter.conf

# set MATE as default session, otherwise login will fail
sed -i 's/^#user-session=.*/user-session=mate/' /etc/lightdm/lightdm.conf

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
echo "POST MATE DESKTOP ************************************"
echo ""

# Defaults for user configuration
mkdir -p /etc/skel/.config

# QT4 looks like GTK+
cat > /etc/skel/.config/Trolltech.conf << TROLLTECH_EOF
[Qt]
style=GTK+
TROLLTECH_EOF

# Override default MATE settings
sed -i "s/^hinting=.*/hinting='full'/"  /usr/share/glib-2.0/schemas/mate-fedora.gschema.override
sed -i "s/^cursor-theme=.*/cursor-theme='Adwaita'/"  /usr/share/glib-2.0/schemas/mate-fedora.gschema.override
sed -i "s/^gtk-theme=.*/gtk-theme='Adwaita'/"  /usr/share/glib-2.0/schemas/mate-fedora.gschema.override
glib-compile-schemas  /usr/share/glib-2.0/schemas

%end
