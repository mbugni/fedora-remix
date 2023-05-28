# kde-base.ks
#
# Defines the basics for the KDE desktop.

%post

# set default GTK+ theme for root (see #683855, #689070, #808062)
cat > /root/.gtkrc-2.0 << EOF
include "/usr/share/themes/Adwaita/gtk-2.0/gtkrc"
include "/etc/gtk-2.0/gtkrc"
gtk-theme-name="Adwaita"
EOF
mkdir -p /root/.config/gtk-3.0
cat > /root/.config/gtk-3.0/settings.ini << EOF
[Settings]
gtk-theme-name = Adwaita
EOF

# set livesys session type
sed -i 's/^livesys_session=.*/livesys_session="kde"/' /etc/sysconfig/livesys

# add extra livesys script
mkdir -p /var/lib/livesys
cat >> /var/lib/livesys/livesys-session-extra << EOF_LIVESYS
# Use KDE X11 for auto-login session
sed -i "s/^Session=.*/Session=plasmax11.desktop/" /etc/sddm.conf
EOF_LIVESYS

cat >> /etc/sddm.conf.d/local.conf << EOF_SDDM
[General]
# Control x11/wayland startup
DisplayServer=x11
EOF_SDDM

%end
