## f17-kde.ks

%include f17-common.ks

part / --size 4096

%packages

### The KDE-Desktop

# Unwanted stuff
-abrt*
-*akonadi*
-gnome*
-kdepim*
-libreoffice-kde

amarok
apper
ark
bluedevil
cagibi
digikam
gwenview
k3b
k3b-extras-freeworld
kamoso
kcalc
kcharselect
kcm-gtk
kcm_touchpad
kde-baseapps
kde-l10n-Italian
kdeplasma-addons
kde-plasma-ktorrent
kde-plasma-networkmanagement
kde-settings-pulseaudio
kde-workspace
kdegraphics-thumbnailers
kmix
kscd
kdm
kgamma
ksnapshot
kwallet
kwebkitpart
kate
okular
oxygen-gtk
phonon-backend-gstreamer
skanlite
svgpart
sweeper
xsettings-kde
xterm

# Fallback icons for some gtk apps 
gnome-icon-theme-symbolic

### @graphical-internet
firefox
icedtea-web
pidgin
thunderbird

### Multimedia
kffmpegthumbnailer
gnash-plugin
vlc
npapi-vlc

### Office
libreoffice
libreoffice-langpack-it

## Tools
gparted


### fixes

# use kde-print-manager instead of system-config-printer
-system-config-printer
kde-print-manager

# make sure alsaunmute is there
alsa-utils

# make sure gnome-packagekit doesn't end up the KDE live images
-gnome-packagekit*

%end


%post

# create /etc/sysconfig/desktop (needed for installation)
cat > /etc/sysconfig/desktop <<EOF
DESKTOP="KDE"
DISPLAYMANAGER="KDE"
EOF

# make oxygen-gtk the default GTK+ theme for root (see #683855, #689070, #808062)
cat > /root/.gtkrc-2.0 << EOF
include "/usr/share/themes/oxygen-gtk/gtk-2.0/gtkrc"
include "/etc/gtk-2.0/gtkrc"
gtk-theme-name="oxygen-gtk"
EOF
mkdir -p /root/.config/gtk-3.0
cat > /root/.config/gtk-3.0/settings.ini << EOF
[Settings]
gtk-theme-name = oxygen-gtk
EOF

# add initscript
cat >> /etc/rc.d/init.d/livesys << EOF

if [ -e /usr/share/icons/hicolor/96x96/apps/fedora-logo-icon.png ] ; then
    # use image also for kdm
    mkdir -p /usr/share/apps/kdm/faces
    cp /usr/share/icons/hicolor/96x96/apps/fedora-logo-icon.png /usr/share/apps/kdm/faces/fedora.face.icon
fi

# make liveuser use KDE
echo "startkde" > /home/liveuser/.xsession
chmod a+x /home/liveuser/.xsession
chown liveuser:liveuser /home/liveuser/.xsession

# set up autologin for user liveuser
sed -i 's/#AutoLoginEnable=true/AutoLoginEnable=true/' /etc/kde/kdm/kdmrc
sed -i 's/#AutoLoginUser=fred/AutoLoginUser=liveuser/' /etc/kde/kdm/kdmrc

# set up user liveuser as default user and preselected user
sed -i 's/#PreselectUser=Default/PreselectUser=Default/' /etc/kde/kdm/kdmrc
sed -i 's/#DefaultUser=johndoe/DefaultUser=liveuser/' /etc/kde/kdm/kdmrc

# add liveinst.desktop to favorites menu
mkdir -p /home/liveuser/.kde/share/config/
cat > /home/liveuser/.kde/share/config/kickoffrc << MENU_EOF
[Favorites]
FavoriteURLs=/usr/share/applications/firefox.desktop,/usr/share/applications/kde4/dolphin.desktop,/usr/share/applications/kde4/systemsettings.desktop,/usr/share/applications/liveinst.desktop
MENU_EOF

# show liveinst.desktop on desktop and in menu
sed -i 's/NoDisplay=true/NoDisplay=false/' /usr/share/applications/liveinst.desktop

# chmod +x ~/Desktop/liveinst.desktop to disable KDE's security warning
chmod +x /usr/share/applications/liveinst.desktop

# copy over the icons for liveinst to hicolor
cp /usr/share/icons/gnome/16x16/apps/system-software-install.png /usr/share/icons/hicolor/16x16/apps/
cp /usr/share/icons/gnome/22x22/apps/system-software-install.png /usr/share/icons/hicolor/22x22/apps/
cp /usr/share/icons/gnome/24x24/apps/system-software-install.png /usr/share/icons/hicolor/24x24/apps/
cp /usr/share/icons/gnome/32x32/apps/system-software-install.png /usr/share/icons/hicolor/32x32/apps/
cp /usr/share/icons/gnome/48x48/apps/system-software-install.png /usr/share/icons/hicolor/48x48/apps/
cp /usr/share/icons/gnome/256x256/apps/system-software-install.png /usr/share/icons/hicolor/256x256/apps/
touch /usr/share/icons/hicolor/

# Set akonadi backend
mkdir -p /home/liveuser/.config/akonadi
cat > /home/liveuser/.config/akonadi/akonadiserverrc << AKONADI_EOF
[%General]
Driver=QSQLITE3
AKONADI_EOF

# Disable the update notifications of apper 
cat > /home/liveuser/.kde/share/config/apper << APPER_EOF
[CheckUpdate]
autoUpdate=0
interval=0
APPER_EOF

# Disable kres-migrator
cat > /home/liveuser/.kde/share/config/kres-migratorrc << KRES_EOF
[Migration]
Enabled=false
KRES_EOF

# Disable nepomuk
cat > /home/liveuser/.kde/share/config/nepomukserverrc << NEPOMUK_EOF
[Basic Settings]
Start Nepomuk=false

[Service-nepomukfileindexer]
autostart=false
NEPOMUK_EOF

# make sure to set the right permissions and selinux contexts
chown -R liveuser:liveuser /home/liveuser/
restorecon -R /home/liveuser/

# small hack to enable plasma-netbook workspace on boot
if strstr "\`cat /proc/cmdline\`" netbook ; then
   mv /usr/share/autostart/plasma-desktop.desktop /usr/share/autostart/plasma-netbook.desktop
   sed -i 's/desktop/netbook/g' /usr/share/autostart/plasma-netbook.desktop
fi
EOF

%end


## REMIX kde

%post

echo -e "\n**********\nPOST KDE\n**********\n"

# Default apps: vlc, firefox
echo '[Added Associations]' > /usr/local/share/applications/mimeapps.list
grep kde4-dragonplayer.desktop /usr/share/kde-settings/kde-profile/default/share/applications/defaults.list \
	| sed 's/kde4-dragonplayer.desktop/vlc.desktop/g' >> /usr/local/share/applications/mimeapps.list
grep kde4-konqueror.desktop /usr/share/kde-settings/kde-profile/default/share/applications/defaults.list \
	| sed 's/kde4-konqueror.desktop/firefox.desktop/g' >> /usr/local/share/applications/mimeapps.list

# Disable the update notifications of apper
cat > /etc/kde/apper << APPER_EOF
[CheckUpdate]
autoUpdate=0
interval=0
APPER_EOF

cat > /etc/kde/kdeglobals << GLOBALS_EOF
[General]
BrowserApplication[\$e]=firefox.desktop

[Locale]
Country=it
Language=it:en_US
GLOBALS_EOF

# Add defaults to favorites menu
cat > /etc/kde/kickoffrc << KICKOFF_EOF
[Favorites]
FavoriteURLs=/usr/share/applications/kde4/systemsettings.desktop,/usr/share/applications/firefox.desktop,/usr/share/applications/kde4/dolphin.desktop,/usr/share/applications/kde4/konsole.desktop
KICKOFF_EOF

# Avoid konqueror preload
cat > /etc/kde/konquerorrc << KONQUEROR_EOF
[Reusing]
AlwaysHavePreloaded=false
MaxPreloadCount=0
PreloadOnStartup=false
KONQUEROR_EOF

# Set Thunderbird as default email client
cat > /etc/kde/emaildefaults << EMAILDEFAULTS_EOF
[Defaults]
Profile=Default

[PROFILE_Default]
EmailClient[\$e]=thunderbird
TerminalClient=false
EMAILDEFAULTS_EOF

# oxygen-gtk3 as default gtk3 theme
if [ ! -d "/etc/skel/.config/gtk-3.0" ]; then
  mkdir -p /etc/skel/.config/gtk-3.0
fi
cat > /etc/skel/.config/gtk-3.0/settings.ini << EOF_SETTINGS_GTK3
[Settings]
gtk-theme-name = oxygen-gtk
gtk-icon-theme-name = oxygen
gtk-fallback-icon-theme = gnome
EOF_SETTINGS_GTK3

%end

