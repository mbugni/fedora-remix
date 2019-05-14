## f27-kde-desktop.ks

%include f27-base-desktop.ks
%include f27-kde-packages.ks

%post

# set default GTK+ theme for root (see #683855, #689070, #808062)
mkdir -p /etc/gtk-2.0
cat > /etc/gtk-2.0/gtkrc << EOF_GTK2
include "/usr/share/themes/Adwaita/gtk-2.0/gtkrc"
gtk-icon-theme-name = "breeze"
gtk-fallback-icon-theme = "hicolor"
gtk-cursor-theme-name = "breeze_cursors"
style "user-font"
{
    font_name="Sans Serif "
}
gtk-font-name="Sans Serif  10"
EOF_GTK2

# add initscript
cat >> /etc/rc.d/init.d/livesys << EOF

# set up autologin for user liveuser
if [ -f /etc/sddm.conf ]; then
sed -i 's/^#User=.*/User=liveuser/' /etc/sddm.conf
sed -i 's/^#Session=.*/Session=plasma.desktop/' /etc/sddm.conf
else
cat > /etc/sddm.conf << SDDM_EOF
[Autologin]
User=liveuser
Session=plasma.desktop
SDDM_EOF
fi

# add liveinst.desktop to favorites menu
mkdir -p /home/liveuser/.config/
cat > /home/liveuser/.config/kickoffrc << MENU_EOF
[Favorites]
FavoriteURLs=/usr/share/applications/firefox.desktop,/usr/share/applications/org.kde.dolphin.desktop,/usr/share/applications/systemsettings.desktop,/usr/share/applications/org.kde.konsole.desktop,/usr/share/applications/liveinst.desktop
MENU_EOF

# show liveinst.desktop on desktop and in menu
sed -i 's/NoDisplay=true/NoDisplay=false/' /usr/share/applications/liveinst.desktop
# set executable bit disable KDE security warning
chmod +x /usr/share/applications/liveinst.desktop
mkdir /home/liveuser/Desktop
cp -a /usr/share/applications/liveinst.desktop /home/liveuser/Desktop/

# Set akonadi backend
mkdir -p /home/liveuser/.config/akonadi
cat > /home/liveuser/.config/akonadi/akonadiserverrc << AKONADI_EOF
[%General]
Driver=QSQLITE3
AKONADI_EOF

# Disable baloo
cat > /home/liveuser/.config/baloofilerc << BALOO_EOF
[Basic Settings]
Indexing-Enabled=false
BALOO_EOF

# Disable kres-migrator
cat > /home/liveuser/.kde/share/config/kres-migratorrc << KRES_EOF
[Migration]
Enabled=false
KRES_EOF

# Disable kwallet migrator
cat > /home/liveuser/.config/kwalletrc << KWALLET_EOL
[Migration]
alreadyMigrated=true
KWALLET_EOL

# make sure to set the right permissions and selinux contexts
chown -R liveuser:liveuser /home/liveuser/
restorecon -R /home/liveuser/

EOF

%end


%post

echo ""
echo "POST KDE DESKTOP *************************************"
echo ""

# Defaults for user configuration
mkdir -p /etc/skel/.config

# Create a default icon for user login face
ln -s /usr/share/sddm/faces/.face.icon /etc/skel/.face
ln -s './.face' /etc/skel/.face.icon

# Disable baloo
cat > /etc/skel/.config/baloofilerc << BALOO_EOF
[Basic Settings]
Indexing-Enabled=false
BALOO_EOF

# Add defaults to favorites menu
cat > /etc/skel/.config/kickoffrc << KICKOFF_EOF
[Favorites]
FavoriteURLs=/usr/share/applications/systemsettings.desktop,/usr/share/applications/firefox.desktop,/usr/share/applications/org.kde.dolphin.desktop,/usr/share/applications/org.kde.konsole.desktop
KICKOFF_EOF

# User global settings
cat > /etc/skel/.config/kdeglobals << GLOBALS_EOF
[General]
XftAntialias=true

[KDE]
SingleClick=false

GLOBALS_EOF

# Launcher settings
cat > /etc/skel/.config/klaunchrc << KLAUNCHRC_EOF
[BusyCursorSettings]
Timeout=6

[TaskbarButtonSettings]
Timeout=6
KLAUNCHRC_EOF

# Session settings
cat > /etc/skel/.config/ksmserverrc << KSMSERVERRC_EOF
[General]
loginMode=default
KSMSERVERRC_EOF

# System global settings
cat > /etc/kde/kdeglobals << GLOBALS_EOF
[KDE]
SingleClick=false

GLOBALS_EOF

# Set Thunderbird as default email client
cat > /etc/kde/emaildefaults << EMAILDEFAULTS_EOF
[Defaults]
Profile=Default

[PROFILE_Default]
EmailClient[\$e]=thunderbird
TerminalClient=false
EMAILDEFAULTS_EOF

%end
