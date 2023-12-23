# kde-desktop.ks
#
# Provides a basic Linux box based on KDE desktop.

%include base-desktop.ks
%include base-extras.ks
%include base-flatpak.ks
%include kde-base.ks

%packages --excludeWeakdeps

# Multimedia
ffmpegthumbs

# Software
flatpak-kcm

# KDE desktop
aha                     # Convert terminal output to HTML for KDE tools
ark
breeze-gtk
cagibi
dolphin
featherpad
fedora-release-kde
gwenview
ibus-uniemoji
kcalc
kcharselect
kcm_systemd
kde-gtk-config
kde-style-breeze
kdeplasma-addons
kinfocenter
kgamma
konsole5
kscreen
kwalletmanager5
kwin
okular
pam-kwallet
plasma-breeze
plasma-desktop
plasma-milou
plasma-nm               # Network Manager
plasma-pa               # Pulse Audio
plasma-systemmonitor
plasma-thunderbolt
plasma-workspace
plasma-workspace-x11
polkit-kde
sddm-x11
sddm-breeze
sddm-kcm
spectacle
svgpart
sweeper
upower
xdg-desktop-portal-kde

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
fixed=Noto Sans Mono,11
font=Noto Sans,11
menuFont=Noto Sans,11
smallestReadableFont=Noto Sans,10
toolBarFont=Noto Sans,11

[KDE]
SingleClick=false
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

# Set default text editor
cat > /etc/xdg/mimeapps.list << MIMEAPPS_EOF
[Default Applications]
text/plain=featherpad.desktop;
MIMEAPPS_EOF

# Remove Discover icon and browser from taskmanager
sed -i -e 's/applications:org.kde.discover.desktop//' \
/usr/share/plasma/plasmoids/org.kde.plasma.taskmanager/contents/config/main.xml

%end
