## f20-kde-desktop.ks

%include f20-base-desktop.ks

services --enabled=tdm

repo --name=rpmfusion-free --mirrorlist=http://mirrors.rpmfusion.org/mirrorlist?repo=free-fedora-$releasever&arch=$basearch
repo --name=trinity --mirrorlist=http://ppa.quickbuild.pearsoncomputing.net/trinity/trinity/rpm/f$releasever/trinity-3.5.13-$basearch.list
repo --name=trinity-noarch --mirrorlist=http://ppa.quickbuild.pearsoncomputing.net/trinity/trinity/rpm/f$releasever/trinity-3.5.13-noarch.list

%packages

# Unwanted stuff
-*akonadi*
-gnome*
-kdepim*
-system-config-printer

apper
# ark
bluedevil
cagibi
gwenview
kcalc
# kcharselect
# kcm-gtk
# kcm_touchpad
# kde-baseapps
# kde-l10n-Italian
# kdeplasma-addons
# kde-plasma-nm
# kde-plasma-nm-*vpn*
# kde-settings-pulseaudio
# kde-workspace
# kgpg
kmix
# kdm
# kgamma
# ksnapshot
# kwalletmanager
# kate
okular
oxygen-gtk
oxygen-icon-theme
phonon-backend-gstreamer
# svgpart
# sweeper
xsettings-kde
xterm

#crystal-project
gnome-icon-theme-legacy
kde-style-oxygen
network-manager-applet
polkit-kde
trinity-kcharselect
trinity-ksnapshot
trinity-tdeartwork-style
trinity-tdeartwork-theme-*
trinity-tdebase
trinity-tde-i18n-Italian
trinity-repo
trinity-tdm
#cups-pk-helper
#system-config-printer

# Internet
firefox
thunderbird

# Tools
gparted

%end


%post

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

# make liveuser use KDE
echo "/opt/trinity/bin/startkde" > /home/liveuser/.xsession
chmod a+x /home/liveuser/.xsession
chown liveuser:liveuser /home/liveuser/.xsession

# set up autologin for user liveuser
sed -i 's/#AutoLoginEnable=true/AutoLoginEnable=true/' /etc/trinity/kdm/kdmrc
sed -i 's/#AutoLoginUser=fred/AutoLoginUser=liveuser/' /etc/trinity/kdm/kdmrc

# set up user liveuser as default user and preselected user
sed -i 's/#PreselectUser=Previous/PreselectUser=Default/' /etc/trinity/kdm/kdmrc
sed -i 's/PreselectUser=Previous/PreselectUser=Default/' /etc/trinity/kdm/kdmrc
sed -i 's/#PreselectUser=Default/PreselectUser=Default/' /etc/trinity/kdm/kdmrc
sed -i 's/#DefaultUser=johndoe/DefaultUser=liveuser/' /etc/trinity/kdm/kdmrc
sed -i 's/#UseSAK=false/UseSAK=false/' /etc/trinity/kdm/kdmrc

# show liveinst.desktop on desktop and in menu
sed -i 's/NoDisplay=true/NoDisplay=false/' /usr/share/applications/liveinst.desktop

# chmod +x ~/Desktop/liveinst.desktop to disable security warning
chmod +x /usr/share/applications/liveinst.desktop

# make sure to set the right permissions and selinux contexts
chown -R liveuser:liveuser /home/liveuser/
restorecon -R /home/liveuser/

EOF

%end


%post

echo ""
echo "********************"
echo "POST TRINITY DESKTOP"
echo "********************"

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

# Default apps: firefox
#echo '[Added Associations]' > /usr/local/share/applications/mimeapps.list
#grep kde4-konqueror.desktop /usr/share/kde-settings/kde-profile/default/share/applications/defaults.list \
#	| sed 's/kde4-konqueror.desktop/firefox.desktop/g' >> /usr/local/share/applications/mimeapps.list

# Disable the update notifications of apper
cat > /etc/kde/apper << APPER_EOF
[CheckUpdate]
autoUpdate=0
distroUpgrade=0
interval=0
APPER_EOF

cat > /etc/trinity/kdeglobals << GLOBALS_EOF
[General]
BrowserApplication[\$e]=firefox.desktop

[KDE]
SingleClick=false

[Locale]
Country=it
Language=it:en_US
GLOBALS_EOF

# Disable module: apperd (no update checks)
cat > /etc/kde/kdedrc << KDEDRC_EOF
[Module-apperd]
autoload=false
KDEDRC_EOF

# Add defaults to favorites menu
cat > /etc/trinity/kickoffrc << KICKOFF_EOF
[Favorites]
FavoriteURLs=/usr/share/applications/kde4/systemsettings.desktop,/usr/share/applications/firefox.desktop,/usr/share/applications/kde4/dolphin.desktop,/usr/share/applications/kde4/konsole.desktop
KICKOFF_EOF

# Launcher settings
cat > /etc/trinity/klaunchrc << KLAUNCHRC_EOF
[BusyCursorSettings]
Timeout=6

[TaskbarButtonSettings]
Timeout=6
KLAUNCHRC_EOF

# Avoid konqueror preload
cat > /etc/trinity/konquerorrc << KONQUEROR_EOF
[Reusing]
AlwaysHavePreloaded=false
MaxPreloadCount=0
PreloadOnStartup=false
KONQUEROR_EOF

# Session settings
cat > /etc/trinity/ksmserverrc << KSMSERVERRC_EOF
[General]
loginMode=default
KSMSERVERRC_EOF

# Set Thunderbird as default email client
cat > /etc/trinity/emaildefaults << EMAILDEFAULTS_EOF
[Defaults]
Profile=Default

[PROFILE_Default]
EmailClient[\$e]=thunderbird
TerminalClient=false
EMAILDEFAULTS_EOF

# Disable nepomuk
cat > /etc/kde/nepomukserverrc << NEPOMUK_EOF
[Basic Settings]
Start Nepomuk=false

[Service-nepomukfileindexer]
autostart=false
NEPOMUK_EOF

# Sets oxygen-gtk2 as default gtk2 theme
mkdir -p /etc/gtk-2.0
cat > /etc/gtk-2.0/gtkrc << EOF_GTKRC
include "/usr/share/themes/oxygen-gtk/gtk-2.0/gtkrc"
gtk-icon-theme-name = "oxygen"
gtk-fallback-icon-theme = "gnome"
EOF_GTKRC

# Sets oxygen-gtk3 as default gtk3 theme
mkdir -p /etc/skel/.config/gtk-3.0
cat > /etc/skel/.config/gtk-3.0/settings.ini << EOF_SETTINGS_GTK3
[Settings]
gtk-theme-name = oxygen-gtk
gtk-icon-theme-name = oxygen
gtk-fallback-icon-theme = gnome
EOF_SETTINGS_GTK3

# Sets Oxygen as default qt theme
mkdir -p /etc/skel/.config
cp /etc/Trolltech.conf  /etc/skel/.config/
echo 'style=oxygen' >> /etc/skel/.config/Trolltech.conf

# Mix crystal with oxygen to avoid missing icons
# rsync -a --link-dest=/usr/share/icons/crystal_project/ --ignore-existing /usr/share/icons/crystal_project/ /usr/share/icons/oxygen/

# Sets 'nm-applet' to run automatically
sed 's/NotShowIn=KDE;/#NotShowIn=KDE;/' /etc/xdg/autostart/nm-applet.desktop > /opt/trinity/share/autostart/nm-applet.desktop

%end

