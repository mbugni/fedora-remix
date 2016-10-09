# fedora-livecd-soas.ks
#
# Description:
# - A Sugar environment that you can carry in your pocket
#
# Maintainers:
# - Sebastian Dziallas <sdz AT fedoraproject DOT org>
# - Peter Robinson <pbrobinson AT gmail DOT com>
# - Mel Chua <mchua AT fedoraproject DOT org>

%include fedora-live-mini.ks

part / --size=2048

%packages

# == Core Sugar Platform ==
@sugar-desktop

# explicitly remove these as they're broken
-sugar-read
-sugar-browse

# Add accountservice for gdm lookup of names
accountsservice

# == Platform Components ==
# from http://wiki.sugarlabs.org/go/0.88/Platform_Components
alsa-plugins-pulseaudio
alsa-utils
etoys
csound-python
evince-djvu
gstreamer-plugins-good
gstreamer-plugins-espeak
gstreamer-plugins-bad-free
pygame
pulseaudio
pulseaudio-utils

# Write breaks unless we do this (we don't need it anyway)
-@input-methods

# explicitly remove openbox and add metacity to hopefully deal with what firstboot wants
-openbox
metacity

# Needed to show external hard drives
gvfs

# Needed for battery monitoring and power management
gnome-power-manager

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

# == Fonts ==
# More font support according to:
# http://bugs.sugarlabs.org/ticket/1119
# Moved to mini.ks

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
Sugar on a Stick 6 (Pineapple)
Fedora release 16 (Verne)
EOF

cat >> /etc/rc.d/init.d/livesys-late << EOF

# run lokkit as firewall command doesn't seem to work
lokkit --enabled --service=mdns

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

# Create a default gnome keyring - should fix RHBZ # 649013
if [ ! -e /home/liveuser/.gnome2/keyrings/login.keyring ]; then
mkdir -p /home/liveuser/.gnome2/keyrings
cat >> /home/liveuser/.gnome2/keyrings/login.keyring << FOE
[keyring]
display-name=login
ctime=1302886515
mtime=1302886515
lock-on-idle=false
lock-timeout=0
FOE

chown -R liveuser:liveuser /home/liveuser/.gnome2/keyrings
fi

# Add our activities to the favorites
cat > /usr/share/sugar/data/activities.defaults << FOE
org.laptop.AbiWordActivity
org.laptop.Chat
org.laptop.Calculate
org.laptop.Clock
org.laptop.ImageViewerActivity
org.laptop.Log
org.laptop.Memorize
org.laptop.physics
org.laptop.Pippy
org.laptop.RecordActivity
org.laptop.Surf
org.laptop.Terminal
org.laptop.TurtleArtActivity
org.laptop.community.TypingTurtle
org.laptop.sugar.Jukebox
com.laptop.Ruler
org.sugarlabs.AbacusActivity
org.sugarlabs.IRC
org.sugarlabs.VisualMatchActivity
org.vpri.EtoysActivity
com.garycmartin.Moon
tv.alterna.Clock
vu.lux.olpc.Maze
vu.lux.olpc.Speak
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
