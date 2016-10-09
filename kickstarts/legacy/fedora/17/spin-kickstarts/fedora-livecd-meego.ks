# Maintained by the Fedora Mini SIG:
# https://fedoraproject.org/wiki/SIGs/FedoraMini

%include fedora-live-mini.ks

%packages

# MeeGo NetBook UX
@meego-netbook
notification-daemon
gnome-terminal
empathy
gypsy
geoclue-gypsy
firefox
dates
contacts
tasks

# remove while it crashes X
# gnome-bluetooth-moblin

# telepathy IM protocols
telepathy-salut
telepathy-sofiasip
telepathy-gabble
telepathy-farsight
telepathy-butterfly

# Some useful gnome tools
cheese
nautilus

# display managers
gdm

%end

%post
cat >> /etc/rc.d/init.d/livesys << EOF
# disable screensaver locking
gconftool-2 --direct --config-source=xml:readwrite:/etc/gconf/gconf.xml.defaults -s -t bool /apps/gnome-screensaver/lock_enabled false >/dev/null
gconftool-2 --direct --config-source=xml:readwrite:/etc/gconf/gconf.xml.defaults -s -t bool /desktop/gnome/lockdown/disable_lock_screen true >/dev/null

# Set up auto-login for for liveuser
cat >> /etc/gdm/custom.conf << FOE
[daemon]
AutomaticLoginEnable=true
AutomaticLogin=liveuser
FOE

# Set the Moblin icon/cursor/gtk theme
cat > /etc/gtk-2.0/gtkrc << FOE
gtk-theme-name = "Moblin-Netbook"
gtk-icon-theme-name = "moblin"
gtk-cursor-theme-name = "moblin"
gtk-button-images = 0
gtk-menu-images = 0
FOE

# Add favourite apps to MyZone
mkdir -p /etc/skel/.local/share/
cat > /etc/skel/.local/share/favourite-apps << FOE
file:///usr/share/applications/moblin-app-installer.desktop file:///usr/share/applications/anjal.desktop file:///usr/share/applications/firefox.desktop file:///usr/share
/applications/fedora-empathy.desktop file:///usr/share/applications/hornsey.desktop file:///usr/share/applications/fedora-dates.desktop file:///usr/share/applications/fedora-con
tacts.desktop file:///usr/share/applications/fedora-tasks.desktop
FOE

cat >> /etc/init.d/livesys << FOE

# Add the moblin favourite icons
mkdir -p /home/liveuser/.local/share/
cp /etc/skel/.local/share/favourite-apps /home/liveuser/.local/share/
FOE

# Turn off PackageKit-command-not-found while uninstalled
sed -i -e 's/^SoftwareSourceSearch=true/SoftwareSourceSearch=false/' /etc/PackageKit/CommandNotFound.conf

EOF

%end
