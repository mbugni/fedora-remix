# fedora-livecd-soas.ks
#
# Description:
# - A Sugar environment that you can carry in your pocket
#
# Maintainers:
# - Peter Robinson <pbrobinson AT gmail DOT com>
# - Sebastian Dziallas <sdz AT fedoraproject DOT org>
# - Mel Chua <mchua AT fedoraproject DOT org>

%include fedora-live-base.ks
%include fedora-live-minimization.ks
%include fedora-soas-packages.ks

firewall --enabled --service=mdns,presence

%post

# Rebuild initrd for Sugar boot screen
KERNEL_VERSION=$(rpm -q kernel --qf '%{version}-%{release}.%{arch}\n')
/usr/sbin/plymouth-set-default-theme sugar
/sbin/dracut -f /boot/initramfs-$KERNEL_VERSION.img $KERNEL_VERSION

# Note that running rpm recreates the rpm db files which aren't needed or wanted
rm -f /var/lib/rpm/__db*

# Get proper release naming in the control panel
cat >> /boot/olpc_build << EOF
Sugar on a Stick
EOF
cat /etc/fedora-release >> /boot/olpc_build

# Add our activities to the favorites
cat > /usr/share/sugar/data/activities.defaults << EOF
org.laptop.WebActivity
org.laptop.HelpActivity
org.laptop.Chat
org.laptop.sugar.ReadActivity
org.laptop.sugar.GetBooksActivity
org.laptop.AbiWordActivity
org.laptop.TurtleArtActivity
org.laptop.Calculate
org.laptop.Clock
org.laptop.ImageViewerActivity
org.laptop.Memorize
org.laptop.physics
org.laptop.Pippy
org.laptop.RecordActivity
org.laptop.Oficina
org.laptop.StopWatchActivity
org.laptop.community.Finance
org.laptop.community.TypingTurtle
org.laptop.sugar.Jukebox
org.eq.FotoToon
org.gnome.Labyrinth
com.laptop.Ruler
org.sugarlabs.AbacusActivity
org.sugarlabs.IRC
org.sugarlabs.InfoSlicer
org.sugarlabs.PortfolioActivity
org.sugarlabs.VisualMatchActivity
com.garycmartin.Moon
mulawa.Countries
tv.alterna.Clock
vu.lux.olpc.Maze
vu.lux.olpc.Speak
EOF

cat > /etc/sysconfig/desktop <<EOF
PREFERRED=/usr/bin/sugar
DISPLAYMANAGER=/usr/sbin/lightdm
EOF

# set up lightdm autologin
sed -i 's/^#autologin-user=.*/autologin-user=liveuser/' /etc/lightdm/lightdm.conf
sed -i 's/^#autologin-user-timeout=.*/autologin-user-timeout=0/' /etc/lightdm/lightdm.conf

# Don't use the default system user (in SoaS liveuser) as nick name
# Disable the logout menu item in Sugar
# Enable Sugar power management
cat >/usr/share/glib-2.0/schemas/sugar.soas.gschema.override <<EOF
[org.sugarlabs.user]
default-nick='disabled'

[org.sugarlabs]
show-logout=false

[org.sugarlabs.power]
automatic=true
EOF
/usr/bin/glib-compile-schemas /usr/share/glib-2.0/schemas/sugar.soas.gschema.override

cat >> /etc/rc.d/init.d/livesys << EOF
# set up lightdm autologin
sed -i 's/^#autologin-user=.*/autologin-user=liveuser/' /etc/lightdm/lightdm.conf
sed -i 's/^#autologin-user-timeout=.*/autologin-user-timeout=0/' /etc/lightdm/lightdm.conf
#sed -i 's/^#show-language-selector=.*/show-language-selector=true/' /etc/lightdm/lightdm-gtk-greeter.conf

# set Sugar as default session, otherwise login will fail
sed -i 's/^#user-session=.*/user-session=sugar/' /etc/lightdm/lightdm.conf
EOF

cat >> /etc/rc.d/init.d/livesys-late << EOF

# disable screensaver locking
cat >> /usr/share/glib-2.0/schemas/org.gnome.desktop.screensaver.gschema.override << FOE
[org.gnome.desktop.screensaver]
lock-enabled=false
FOE

# and hide the lock screen option
cat >> /usr/share/glib-2.0/schemas/org.gnome.desktop.lockdown.gschema.override << FOE
[org.gnome.desktop.lockdown]
disable-lock-screen=true
FOE

# rebuild schema cache with any overrides we installed
glib-compile-schemas /usr/share/glib-2.0/schemas

EOF

chmod 755 /etc/rc.d/init.d/livesys-late
/sbin/restorecon /etc/rc.d/init.d/livesys-late
/sbin/chkconfig --add livesys-late

%end
