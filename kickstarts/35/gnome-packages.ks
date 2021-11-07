# gnome-packages.ks
#
# Defines common packages for the GNOME desktop.

%packages --excludeWeakdeps

PackageKit-gtk3-module
NetworkManager-l2tp-gnome
NetworkManager-openvpn-gnome
NetworkManager-pptp-gnome
adwaita-gtk2-theme
chrome-gnome-shell
dconf
dconf-editor
desktop-backgrounds-gnome
evince
evince-nautilus
fedora-release-workstation
file-roller
file-roller-nautilus
gdm
gedit
gnome-bluetooth
gnome-calculator
gnome-characters
# gnome-classic-session     Obsolete
gnome-color-manager
gnome-control-center
gnome-extensions-app
gnome-font-viewer
# gnome-getting-started-docs
gnome-initial-setup
gnome-screenshot
gnome-session-wayland-session
gnome-session-xsession
gnome-settings-daemon
gnome-shell
gnome-shell-extension-topicons-plus
gnome-software
gnome-system-monitor
gnome-terminal
gnome-terminal-nautilus
# gnome-themes-extra
gnome-tweaks
gthumb
gvfs-goa
nautilus
polkit
yelp
xdg-desktop-portal-gtk
xdg-user-dirs-gtk

%end
