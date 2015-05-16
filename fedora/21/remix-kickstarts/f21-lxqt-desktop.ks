## f21-lxqt-desktop.ks

%include f21-base-desktop.ks

%packages

# Unwanted stuff
-*akonadi*
-*baloo*
-*nepomuk*
-gnome*
-kdepim*

ark
bluedevil
# dolphin
kate
kcalc
kcharselect
kcm_colors
kde-l10n-Italian
kde-style-oxygen
kdm
konsole
libfm-gtk
liblxqt-mount
lxqt-about
lxqt-common
lxqt-config
lxqt-globalkeys
lxqt-notificationd
lxqt-openssh-askpass
lxqt-panel
lxqt-policykit
lxqt-powermanagement
lxqt-qtplugin
lxqt-runner
lxqt-session
network-manager-applet
nm-connection-editor
notification-daemon
obconf
okular
openbox
oxygen-gtk2
oxygen-icon-theme
pavucontrol
pcmanfm-qt
phonon-backend-gstreamer
upower
xbacklight
xdg-user-dirs
xsettings-kde
NetworkManager-l2tp
NetworkManager-openvpn
NetworkManager-pptp
xterm

# Internet
firefox
thunderbird

# Tools
gparted

%end


%post

echo ""
echo "*****************"
echo "POST LXQT DESKTOP"
echo "*****************"

# create /etc/sysconfig/desktop (needed for installation)
cat > /etc/sysconfig/desktop <<EOF
DESKTOP="startlxqt"
DISPLAYMANAGER="KDE"
EOF

# make oxygen-gtk the default GTK+ theme for root (see #683855, #689070, #808062)
mkdir -p /etc/gtk-2.0
cat > /etc/gtk-2.0/gtkrc << EOF_GTK2
include "/usr/share/themes/oxygen-gtk/gtk-2.0/gtkrc"
gtk-icon-theme-name = "oxygen"
gtk-fallback-icon-theme = "gnome"
EOF_GTK2
mkdir -p /etc/gtk-3.0
cat > /etc/gtk-3.0/settings.ini << EOF_GTK3
[Settings]
gtk-theme-name = Adwaita
gtk-icon-theme-name = oxygen
gtk-fallback-icon-theme = gnome
EOF_GTK3

# add initscript
cat >> /etc/rc.d/init.d/livesys << EOF

# make liveuser use KDE
echo "startlxqt" > /home/liveuser/.xsession
chmod a+x /home/liveuser/.xsession
chown liveuser:liveuser /home/liveuser/.xsession

# set up autologin for user liveuser
sed -i 's/#AutoLoginEnable=true/AutoLoginEnable=true/' /etc/kde/kdm/kdmrc
sed -i 's/#AutoLoginUser=fred/AutoLoginUser=liveuser/' /etc/kde/kdm/kdmrc

# set up user liveuser as default user and preselected user
sed -i 's/#PreselectUser=Default/PreselectUser=Default/' /etc/kde/kdm/kdmrc
sed -i 's/#DefaultUser=johndoe/DefaultUser=liveuser/' /etc/kde/kdm/kdmrc

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

# Disable the update notifications of apper
cat > /etc/kde/apper << APPER_EOF
[CheckUpdate]
autoUpdate=0
distroUpgrade=0
interval=0
APPER_EOF

cat > /etc/kde/kdeglobals << GLOBALS_EOF
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

# Launcher settings
cat > /etc/kde/klaunchrc << KLAUNCHRC_EOF
[BusyCursorSettings]
Timeout=6

[TaskbarButtonSettings]
Timeout=6
KLAUNCHRC_EOF

# Avoid konqueror preload
cat > /etc/kde/konquerorrc << KONQUEROR_EOF
[Reusing]
AlwaysHavePreloaded=false
MaxPreloadCount=0
PreloadOnStartup=false
KONQUEROR_EOF

# Session settings
cat > /etc/kde/ksmserverrc << KSMSERVERRC_EOF
[General]
loginMode=default
KSMSERVERRC_EOF

# Set Thunderbird as default email client
cat > /etc/kde/emaildefaults << EMAILDEFAULTS_EOF
[Defaults]
Profile=Default

[PROFILE_Default]
EmailClient[\$e]=thunderbird
TerminalClient=false
EMAILDEFAULTS_EOF

# Disable baloo
cat > /etc/kde/baloofilerc << BALOO_EOF
[Basic Settings]
Indexing-Enabled=false
BALOO_EOF

# Sets default Qt5 theme
mkdir -p /etc/skel/.config/lxqt
cat > /etc/skel/.config/lxqt/lxqt.conf << LXQT_CONF_EOF
[Qt]
style=Fusion
LXQT_CONF_EOF

%end
