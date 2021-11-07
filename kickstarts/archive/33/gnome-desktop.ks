# gnome-desktop.ks
#
# Provides a basic Linux box based on GNOME desktop.

%include gnome-base.ks
%include base-remix.ks

%packages --excludeWeakdeps

# Graphics
cheese

# Multimedia
gvfs-mtp
nautilus-extensions
totem
sushi

%end

%post

echo ""
echo "POST GNOME DESKTOP ***********************************"
echo ""

# Set default fonts for GNOME environment
cat > /etc/dconf/db/local.d/01-remix-gnome-fonts << EOF_FONTS
# Remix global font settings

[org/gnome/desktop/interface]
document-font-name='Noto Sans 11'
font-name='Noto Sans 11'
monospace-font-name='Noto Sans Mono 11'

[org/gnome/desktop/wm/preferences]
titlebar-font='Noto Sans 11'

[org/gnome/settings-daemon/plugins/xsettings]
antialiasing='rgba'
hinting='full'
EOF_FONTS

# Update configuration
dbus-launch --exit-with-session dconf update

%end
