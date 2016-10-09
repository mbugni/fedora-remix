## f17-razorqt.ks

%include f17-common.ks

part / --size 4096

%packages

### The RazorQT-Desktop

# Unwanted stuff
-abrt*
-*akonadi*
-gnome*
-kdepim*
-libreoffice-kde
-*nepomuk*

# KDE components
ark
bluedevil
juk
kde-baseapps
kde-l10n-Italian
kdm
kate
konsole
okular
xsettings-kde
xterm

# Audio
pavucontrol
pulseaudio-utils

# Standards
polkit-qt
upower
xdg-utils

# RazorQT components
obconf
openbox
qlipper
qxkb
screengrab
speedcrunch
razorqt
razorqt-themes
# lightdm-razorqt

NetworkManager-gnome

# Theme and icons
oxygen-icon-theme
gtk2-engines
clearlooks-phenix-gtk3-theme

# Fallback icons for some gtk apps 
gnome-icon-theme-symbolic

### @graphical-internet
firefox
# icedtea-web
# pidgin
# thunderbird

### Multimedia
# kffmpegthumbnailer <-- Depends on kde-workspace!
gnash-plugin
vlc
npapi-vlc

### Office
# libreoffice
# libreoffice-langpack-it

## Tools
gparted


### fixes

# use kde-print-manager instead of system-config-printer
# -system-config-printer
# kde-print-manager

# make sure alsaunmute is there
alsa-utils

# make sure gnome-packagekit doesn't end up the KDE live images
-gnome-packagekit*

%end


%post

# create /etc/sysconfig/desktop (needed for installation)
cat > /etc/sysconfig/desktop <<EOF
PREFERRED=/usr/bin/startrazor
DISPLAYMANAGER="KDE"
EOF

# make oxygen-gtk the default GTK+ theme for root (see #683855, #689070, #808062)
#cat > /root/.gtkrc-2.0 << EOF
#include "/usr/share/themes/oxygen-gtk/gtk-2.0/gtkrc"
#include "/etc/gtk-2.0/gtkrc"
#gtk-theme-name="oxygen-gtk"
#EOF
#mkdir -p /root/.config/gtk-3.0
#cat > /root/.config/gtk-3.0/settings.ini << EOF
#[Settings]
#gtk-theme-name = oxygen-gtk
#gtk-fallback-icon-theme = gnome
#EOF

# add initscript
cat >> /etc/rc.d/init.d/livesys << EOF

# make liveuser use RazorQT
chmod a+x /home/liveuser/.xsession
chown liveuser:liveuser /home/liveuser/.xsession

# set up autologin for user liveuser
sed -i 's/#AutoLoginEnable=true/AutoLoginEnable=true/' /etc/kde/kdm/kdmrc
sed -i 's/#AutoLoginUser=fred/AutoLoginUser=liveuser/' /etc/kde/kdm/kdmrc

# show liveinst.desktop on desktop and in menu
sed -i 's/NoDisplay=true/NoDisplay=false/' /usr/share/applications/liveinst.desktop

# chmod +x ~/Desktop/liveinst.desktop to disable KDE's security warning
chmod +x /usr/share/applications/liveinst.desktop

# Disable the update notifications of apper 
# cat > /home/liveuser/.kde/share/config/apper << APPER_EOF
# [CheckUpdate]
# autoUpdate=0
# interval=0
# APPER_EOF

# make sure to set the right permissions and selinux contexts
chown -R liveuser:liveuser /home/liveuser/
restorecon -R /home/liveuser/

EOF

%end


## REMIX razorqt

%post

echo -e "\n************\nPOST RAZORQT\n************\n"

# Default apps: vlc, firefox
echo '[Added Associations]' > /usr/local/share/applications/mimeapps.list
grep kde4-dragonplayer.desktop /usr/share/kde-settings/kde-profile/default/share/applications/defaults.list \
	| sed 's/kde4-dragonplayer.desktop/vlc.desktop/g' >> /usr/local/share/applications/mimeapps.list
grep kde4-konqueror.desktop /usr/share/kde-settings/kde-profile/default/share/applications/defaults.list \
	| sed 's/kde4-konqueror.desktop/firefox.desktop/g' >> /usr/local/share/applications/mimeapps.list

# Disable the update notifications of apper
# cat > /etc/kde/apper << APPER_EOF
# [CheckUpdate]
# autoUpdate=0
# interval=0
# APPER_EOF

# Clearlooks as default style for qt, gtk2 and gtk3
mkdir -p /etc/skel/.config
cp /etc/Trolltech.conf  /etc/skel/.config/
echo 'style=Cleanlooks' >> /etc/skel/.config/Trolltech.conf

cat > /etc/gtk-2.0/gtkrc << EOF_GTKRC
include "/usr/share/themes/Clearlooks/gtk-2.0/gtkrc"
gtk-icon-theme-name = "oxygen"
gtk-fallback-icon-theme = "gnome"
EOF_GTKRC

if [ ! -d "/etc/skel/.config/gtk-3.0" ]; then
  mkdir -p /etc/skel/.config/gtk-3.0
fi
cat > /etc/skel/.config/gtk-3.0/settings.ini << EOF_SETTINGS_GTK3
[Settings]
gtk-theme-name = Clearlooks-Phenix
gtk-icon-theme-name = oxygen
gtk-fallback-icon-theme = gnome
EOF_SETTINGS_GTK3

%end
