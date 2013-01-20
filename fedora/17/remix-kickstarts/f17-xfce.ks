## f17-xfce.ks

%include f17-common.ks

%packages

# Unwanted stuff
-abrt*
-at-*
-caribou*
-gdm*
-gnome-*
-*nodoka*
-orca*
-xarchiver

# Office
libreoffice
libreoffice-langpack-it

# Graphics
evince

# Internet
firefox
pidgin
remmina
remmina-plugins-rdp
remmina-plugins-vnc
thunderbird
transmission-gtk

# Sound & Video
alsa-plugins-pulseaudio
asunder
guvcview
pavucontrol
parole
pragha
xfburn

# System
arandr
gparted
-gnome-disk-utility
gigolo
setroubleshoot

# Accessories
catfish
file-roller
galculator
seahorse
ConsoleKit-x11

# More Desktop stuff
# java plugin
icedtea-web
blueman
gvfs-obexftp
lightdm-gtk
xscreensaver-base
xdg-user-dirs-gtk

# default artwork
fedora-icon-theme
adwaita-cursor-theme
adwaita-gtk2-theme
adwaita-gtk3-theme

# command line
ntfs-3g
vim-enhanced
wget
yum-utils

# Xfce packages
@xfce-desktop
ristretto
thunar-media-tags-plugin
xfce4-battery-plugin
xfce4-cellmodem-plugin
xfce4-clipman-plugin
xfce4-cpugraph-plugin
xfce4-datetime-plugin
#xfce4-dict-plugin
xfce4-diskperf-plugin
#xfce4-eyes-plugin
xfce4-fsguard-plugin
xfce4-genmon-plugin
xfce4-mailwatch-plugin
xfce4-mount-plugin
xfce4-netload-plugin
xfce4-notes-plugin
xfce4-places-plugin
xfce4-quicklauncher-plugin
xfce4-screenshooter-plugin
xfce4-sensors-plugin
xfce4-smartbookmark-plugin
xfce4-systemload-plugin
xfce4-taskmanager
xfce4-time-out-plugin
xfce4-timer-plugin
xfce4-verve-plugin
#xfce4-volumed
# we already have nm-applet
#xfce4-wavelan-plugin
#xfce4-weather-plugin
xfce4-websearch-plugin
xfce4-xkb-plugin
# system-config-printer does printer management better
#xfprint
xfwm4-themes

# dictionaries are big
-aspell-*
#-man-pages-*

# more fun with space saving
-gimp-help
# not needed, but as long as there is space left, we leave this in
#-desktop-backgrounds-basic

# unlock default keyring. FIXME: Should probably be done in comps
gnome-keyring-pam

# save some space
-autofs
-acpid

# drop some system-config things
-system-config-boot
-system-config-lvm
-system-config-network
-system-config-rootpassword
#-system-config-services
-policycoreutils-gui

%end

%post
# xfce configuration

# create /etc/sysconfig/desktop (needed for installation)

cat > /etc/sysconfig/desktop <<EOF
PREFERRED=/usr/bin/startxfce4
DISPLAYMANAGER=/usr/sbin/lightdm
EOF

cat >> /etc/rc.d/init.d/livesys << EOF

mkdir -p /home/liveuser/.config/xfce4

cat > /home/liveuser/.config/xfce4/helpers.rc << FOE
MailReader=thunderbird
FileManager=Thunar
FOE

# disable screensaver locking (#674410)
cat >> /home/liveuser/.xscreensaver << FOE
mode:           off
lock:           False
dpmsEnabled:    False
FOE

# deactivate xfconf-migration (#683161)
rm -f /etc/xdg/autostart/xfconf-migration-4.6.desktop || :

# deactivate xfce4-panel first-run dialog (#693569)
mkdir -p /home/liveuser/.config/xfce4/xfconf/xfce-perchannel-xml
cp /etc/xdg/xfce4/panel/default.xml /home/liveuser/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml

# set up lightdm autologin
sed -i 's/^#autologin-user=.*/autologin-user=liveuser/' /etc/lightdm/lightdm.conf
sed -i 's/^#autologin-user-timeout=.*/autologin-user-timeout=0/' /etc/lightdm/lightdm.conf
#sed -i 's/^#show-language-selector=.*/show-language-selector=true/' /etc/lightdm/lightdm-gtk-greeter.conf

# set Xfce as default session, otherwise login will fail
sed -i 's/^#user-session=.*/user-session=xfce/' /etc/lightdm/lightdm.conf

# Show harddisk install on the desktop
sed -i -e 's/NoDisplay=true/NoDisplay=false/' /usr/share/applications/liveinst.desktop
mkdir /home/liveuser/Desktop
cp /usr/share/applications/liveinst.desktop /home/liveuser/Desktop

# and mark it as executable (new Xfce security feature)
chmod +x /home/liveuser/Desktop/liveinst.desktop

# this goes at the end after all other changes. 
chown -R liveuser:liveuser /home/liveuser
restorecon -R /home/liveuser

EOF

%end

## REMIX xfce

%post

echo -e "\n**********\nPOST XFCE\n**********\n"

# override default gnome settings
cat >> /usr/share/glib-2.0/schemas/org.gnome.remix.gschema.override << GNOME_EOF
[org.gnome.desktop.interface]
font-name='Sans 10'
document-font-name='Sans 10'
monospace-font-name='Monospace 10'

[org.gnome.settings-daemon.plugins.updates]
auto-update-type='none'
frequency-get-updates=0
frequency-get-upgrades=0
GNOME_EOF

glib-compile-schemas /usr/share/glib-2.0/schemas

mkdir -p /etc/skel/.config/xfce4

cat > /etc/skel/.config/xfce4/helpers.rc << FOE
MailReader=thunderbird
FileManager=Thunar
FOE

%end

