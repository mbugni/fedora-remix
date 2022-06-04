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

# Create a default icon for user login face
ln -s /usr/share/sddm/faces/.face.icon /etc/skel/.face
ln -s './.face' /etc/skel/.face.icon

# Disable baloo
cat > /etc/skel/.config/baloofilerc << BALOO_EOF
[Basic Settings]
Indexing-Enabled=false
BALOO_EOF

# User global settings
cat > /etc/skel/.config/kdeglobals << GLOBALS_EOF
[KDE]
SingleClick=false

GLOBALS_EOF

# Sudo settings
cat > /etc/skel/.config/kdesurc << KDESU_EOF
[super-user-command]
super-user-command=sudo
KDESU_EOF

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

# Set Thunderbird as default email client
cat > /etc/skel/.config/emaildefaults << EMAILDEFAULTS_EOF
[Defaults]
Profile=Default

[PROFILE_Default]
EmailClient[\$e]=thunderbird
TerminalClient=false
EMAILDEFAULTS_EOF

%end
