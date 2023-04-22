# kde-desktop.ks
#
# Provides a basic Linux box based on KDE desktop.

%include base-desktop.ks
%include base-extras.ks
%include kde-base.ks

firewall --enabled --service=mdns,kdeconnect

%packages --excludeWeakdeps

# Connectivity
kde-connect
kio_mtp

# Graphics
kamoso
kdegraphics-thumbnailers

# Multimedia
ffmpegthumbs
vlc

%end

%post

echo ""
echo "POST KDE DESKTOP *************************************"
echo ""

# Defaults for user configuration
mkdir -p /etc/skel/.config

# Disable baloo
cat > /etc/xdg/baloofilerc << BALOO_EOF
[Basic Settings]
Indexing-Enabled=false
BALOO_EOF

# User global settings
cat > /etc/xdg/kdeglobals << GLOBALS_EOF
[General]
fixed=Noto Mono,11
font=Noto Sans,11
menuFont=Noto Sans,11
smallestReadableFont=Noto Sans,10
toolBarFont=Noto Sans,11

[KDE]
SingleClick=false

# HOW: https://develop.kde.org/deploy/kiosk/introduction/
# WHY: https://bugzilla.redhat.com/show_bug.cgi?id=1929643
[KDE Action Restrictions]
action/start_new_session=false
action/switch_user=false
GLOBALS_EOF

# Sudo settings
cat > /etc/xdg/kdesurc << KDESU_EOF
[super-user-command]
super-user-command=sudo
KDESU_EOF

# Launcher settings
cat > /etc/xdg/klaunchrc << KLAUNCHRC_EOF
[BusyCursorSettings]
Timeout=6

[TaskbarButtonSettings]
Timeout=6
KLAUNCHRC_EOF

# Set Thunderbird as default email client
cat > /etc/xdg/emaildefaults << EMAILDEFAULTS_EOF
[Defaults]
Profile=Default

[PROFILE_Default]
EmailClient[\$e]=thunderbird
TerminalClient=false
EMAILDEFAULTS_EOF

# No Discover, replace icon by terminal emulator
sed -i 's/applications:org.kde.discover.desktop/applications:org.kde.konsole.desktop/' \
/usr/share/plasma/plasmoids/org.kde.plasma.taskmanager/contents/config/main.xml

%end
