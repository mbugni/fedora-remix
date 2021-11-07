# xfce-desktop.ks
#
# Provides a basic Linux box based on XFCE desktop.

%include xfce-base.ks
%include base-remix.ks

%packages --excludeWeakdeps

# Graphics
guvcview

# Multimedia
celluloid
gvfs-mtp
# parole    # Does not works

%end

%post

echo ""
echo "POST XFCE DESKTOP ************************************"
echo ""

# Defaults for user configuration
mkdir -p /etc/skel/.config/xfce4

# Set default applications
cat > /etc/skel/.config/xfce4/helpers.rc << HELPERS_EOF
WebBrowser=firefox
MailReader=thunderbird
HELPERS_EOF

# Mute bell autostart utility
cat > /etc/xdg/autostart/mute-bell-sound.desktop << MUTEBELLSOUND_EOF
[Desktop Entry]
Name=Mute Bell Sound
Name[it]=Silenzia Campanella
Comment=Mute system bell sound
Comment[it]=Disattiva la campanella di sistema
Icon=notifications-disabled-symbolic.symbolic
Exec=/usr/bin/xset b off
Terminal=false
Type=Application
OnlyShowIn=XFCE;
MUTEBELLSOUND_EOF

%end
