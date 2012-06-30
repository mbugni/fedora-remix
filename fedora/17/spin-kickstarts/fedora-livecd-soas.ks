# fedora-livecd-soas.ks
#
# Description:
# - A Sugar environment that you can carry in your pocket
#
# Maintainers:
# - Peter Robinson <pbrobinson AT gmail DOT com>
# - Sebastian Dziallas <sdz AT fedoraproject DOT org>
# - Mel Chua <mchua AT fedoraproject DOT org>

%include fedora-live-mini.ks

part / --size=3072
firewall --enabled --service=mdns,presence

%packages

# == Core Sugar Platform ==
@sugar-desktop

# Write breaks unless we do this (we don't need it anyway)
# enable for testing in the F17 dev cycle
@input-methods

# == Platform Components ==
# from http://wiki.sugarlabs.org/go/0.94/Platform_Components
alsa-plugins-pulseaudio
alsa-utils
gstreamer-plugins-good
gstreamer-plugins-espeak
gstreamer-plugins-bad-free
pulseaudio
pulseaudio-utils

# explicitly remove openbox and add metacity to hopefully deal with what firstboot wants
-openbox

# Usefulness for DSL connections as per:
# http://bugs.sugarlabs.org/ticket/1951
rp-pppoe
# Useful for SoaS duplication from:
# http://bugs.sugarlabs.org/ticket/74
livecd-tools

# Get the Sugar boot screen
-plymouth-system-theme
-plymouth-theme-charge
sugar-logos

# == Hardware ==
# Lets support Broadcom and XO wifi hardware
b43-openfwwf
libertas-usb8388-firmware

%end

%post

# Rebuild initrd for Sugar boot screen
KERNEL_VERSION=$(rpm -q kernel --qf '%{version}-%{release}.%{arch}\n')
/usr/sbin/plymouth-set-default-theme sugar
/sbin/dracut -f /boot/initramfs-$KERNEL_VERSION.img $KERNEL_VERSION

# Note that running rpm recreates the rpm db files which aren't needed or wanted
rm -f /var/lib/rpm/__db*

# Get proper release naming in the control panel
cat >> /boot/olpc_build << EOF
Sugar on a Stick 7 (Quandong)
Fedora release 17 (Beefy Miracle)
EOF

cat >> /etc/rc.d/init.d/livesys-late << EOF

# Don't use the default system user (in SoaS liveuser) as nick name
gconftool-2 --direct --config-source=xml:readwrite:/etc/gconf/gconf.xml.defaults -s -t string /desktop/sugar/user/default_nick disabled >/dev/null

# Disable the logout menu item in Sugar
gconftool-2 --direct --config-source=xml:readwrite:/etc/gconf/gconf.xml.defaults -s -t bool /desktop/sugar/show_logout false >/dev/null

# Enable Sugar power management
gconftool-2 --direct --config-source=xml:readwrite:/etc/gconf/gconf.xml.defaults -s -t bool /desktop/sugar/power/automatic True >/dev/null

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

# disable updates plugin
cat >> /usr/share/glib-2.0/schemas/org.gnome.settings-daemon.plugins.updates.gschema.override << FOE
[org.gnome.settings-daemon.plugins.updates]
active=false
FOE

# Add our activities to the favorites
cat > /usr/share/sugar/data/activities.defaults << FOE
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
org.laptop.community.TypingTurtle
org.laptop.sugar.Jukebox
org.gnome.Labyrinth
com.laptop.Ruler
org.sugarlabs.AbacusActivity
org.sugarlabs.IRC
org.sugarlabs.Infoslicer
org.sugarlabs.PortfolioActivity
org.sugarlabs.VisualMatchActivity
com.garycmartin.Moon
mulawa.Countries
tv.alterna.Clock
vu.lux.olpc.Maze
vu.lux.olpc.Speak
org.laptop.community.Finance
org.laptop.Terminal
org.laptop.Log
FOE

# rebuild schema cache with any overrides we installed
glib-compile-schemas /usr/share/glib-2.0/schemas

# set up timed auto-login for after 60 seconds
cat >> /etc/gdm/custom.conf << FOE
[daemon]
AutomaticLoginEnable=True
AutomaticLogin=liveuser
FOE

EOF

chmod 755 /etc/rc.d/init.d/livesys-late
/sbin/restorecon /etc/rc.d/init.d/livesys-late
/sbin/chkconfig --add livesys-late

%end
