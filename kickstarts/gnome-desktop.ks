# gnome-desktop.ks
#
# Provides a basic Linux box based on GNOME desktop.

%include base-desktop.ks
%include base-extras.ks
%include gnome-base.ks

%packages --excludeWeakdeps

# Graphics
cheese

# Multimedia
ffmpegthumbnailer
nautilus-extensions
sushi
vlc

# GNOME desktop
PackageKit-gtk3-module
adwaita-gtk2-theme
dconf
dconf-editor
desktop-backgrounds-gnome
evince
fedora-release-workstation
file-roller
file-roller-nautilus
gdm
gedit
gnome-calculator
gnome-characters
gnome-color-manager
gnome-control-center
gnome-extensions-app
gnome-font-viewer
gnome-initial-setup
gnome-screenshot
gnome-session-wayland-session
gnome-session-xsession
gnome-settings-daemon
gnome-shell
gnome-shell-extension-appindicator
gnome-system-monitor
gnome-terminal
gnome-terminal-nautilus
gnome-tweaks
gthumb
gvfs-goa
nautilus
polkit
webp-pixbuf-loader          # For images and backgrounds
xdg-desktop-portal-gtk
xdg-user-dirs-gtk
yelp

%end

%post

echo ""
echo "POST GNOME DESKTOP ***********************************"
echo ""

# Default settings for GNOME environment
cat > /etc/dconf/db/local.d/01-remix-gnome-settings << EOF_SETTINGS
# Global fonts settings
[org/gnome/desktop/interface]
document-font-name='Noto Sans 11'
font-name='Noto Sans 11'
monospace-font-name='Noto Sans Mono 11'

[org/gnome/desktop/wm/preferences]
titlebar-font='Noto Sans 11'

[org/gnome/settings-daemon/plugins/xsettings]
antialiasing='rgba'
hinting='full'

# Disable device automount
[org/gnome/desktop/media-handling]
automount=false
automount-open=false
EOF_SETTINGS

# Update configuration
dbus-launch --exit-with-session dconf update

%end
