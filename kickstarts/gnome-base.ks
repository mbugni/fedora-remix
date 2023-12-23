# gnome-base.ks
#
# Defines the basics for the GNOME desktop.

%post

# set livesys session type
sed -i 's/^livesys_session=.*/livesys_session="gnome"/' /etc/sysconfig/livesys

# add extra livesys script
mkdir -p /var/lib/livesys
cat >> /var/lib/livesys/livesys-session-extra << EOF_LIVESYS
# Override favorite apps for GNOME
APPS_OVERRIDE="['firefox.desktop','org.gnome.Nautilus.desktop','liveinst.desktop']"
sed -i "s/^favorite-apps=.*/favorite-apps=\${APPS_OVERRIDE}/" /usr/share/glib-2.0/schemas/org.gnome.shell.gschema.override

# rebuild schema cache with any overrides we installed
glib-compile-schemas /usr/share/glib-2.0/schemas
EOF_LIVESYS

%end
