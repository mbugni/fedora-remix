## fedora-remix-kde.ks

%include f16-remix-common.ks

part / --size 3584

%packages

### The KDE-Desktop

# Unwanted stuff
-abrt*
-gnome*
-kdepim*

@kde-desktop --nodefaults
amarok
apper
bluedevil
cagibi
cups-pk-helper
digikam
k3b
kamoso
kcm-gtk
kcm_touchpad
kde-baseapps
kde-l10n-Italian
kdeplasma-addons
kde-plasma-networkmanagement
kde-settings-pulseaudio
kdegraphics
kdemultimedia-kmix
kdemultimedia-kscd
kdenetwork-kopete
kdeutils
kdm
kipi-plugins
kwebkitpart
oxygen-gtk*
phonon-backend-gstreamer
xsettings-kde
xterm

### Internet
firefox
thunderbird

### Multimedia
gnash-plugin
vlc
npapi-vlc

## System Tools
kde-partitionmanager

## Tools
kffmpegthumbnailer

### fixes

# use system-config-printer-kde instead of system-config-printer
-system-config-printer
system-config-printer-kde

# make sure alsaunmute is there
alsa-utils

# make sure gnome-packagekit doesn't end up the KDE live images
-gnome-packagekit*

# pull in adwaita-gtk3-theme as long as we don't have native GTK+ 3 theming
# adwaita-gtk3-theme

%end


%post

# create /etc/sysconfig/desktop (needed for installation)
cat > /etc/sysconfig/desktop <<EOF
DESKTOP="KDE"
DISPLAYMANAGER="KDE"
EOF

# make oxygen-gtk the default GTK+ 2 theme for root (see #683855, #689070)
cat > /root/.gtkrc-2.0 << EOF
include "/usr/share/themes/oxygen-gtk/gtk-2.0/gtkrc"
include "/etc/gtk-2.0/gtkrc"
gtk-theme-name="oxygen-gtk"
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
FavoriteURLs=/usr/share/applications/mozilla-firefox.desktop,/usr/share/applications/kde4/dolphin.desktop,/usr/share/applications/kde4/systemsettings.desktop,/usr/share/applications/liveinst.desktop
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

[Service-nepomukstrigiservice]
autostart=false
NEPOMUK_EOF

# make sure to set the right permissions and selinux contexts
chown -R liveuser:liveuser /home/liveuser/
restorecon -R /home/liveuser/

# don't use prelink on a running KDE live image
sed -i 's/PRELINKING=yes/PRELINKING=no/' /etc/sysconfig/prelink

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
	| sed 's/kde4-konqueror.desktop/mozilla-firefox.desktop/g' >> /usr/local/share/applications/mimeapps.list

# Firefox as default browser
sed -i '/^\[General\]$/a BrowserApplication[$e]=mozilla-firefox.desktop' /usr/share/kde-settings/kde-profile/default/share/config/kdeglobals

# Disable the update notifications of apper
sed -i 's/interval=.*/interval=0/g' /usr/share/kde-settings/kde-profile/default/share/config/apper

# Add defaults to favorites menu
cat > /usr/share/kde-settings/kde-profile/default/share/config/kickoffrc << KICKOFF_EOF
[Favorites]
FavoriteURLs=/usr/share/applications/kde4/systemsettings.desktop,/usr/share/applications/mozilla-firefox.desktop,/usr/share/applications/kde4/dolphin.desktop,/usr/share/applications/kde4/konsole.desktop
KICKOFF_EOF

# Avoid konqueror preload
cat >> /usr/share/kde-settings/kde-profile/default/share/config/konquerorrc << KONQUEROR_EOF

[Reusing]
AlwaysHavePreloaded=false
MaxPreloadCount=0
PreloadOnStartup=false
KONQUEROR_EOF

# Set Thunderbird as default email client
cat > /usr/share/kde-settings/kde-profile/default/share/config/emaildefaults << EMAILDEFAULTS_EOF
[Defaults]
Profile=Default

[PROFILE_Default]
EmailClient[$e]=thunderbird
TerminalClient=false
EMAILDEFAULTS_EOF

# oxygen-gtk3 as default gtk3 theme
if [ ! -d "/etc/skel/.config/gtk-3.0" ]; then
  mkdir -p /etc/skel/.config/gtk-3.0
fi
cat > /etc/skel/.config/gtk-3.0/settings.ini << EOF_SETTINGS_GTK3
[Settings]
gtk-theme-name = oxygen-gtk
EOF_SETTINGS_GTK3

%end

