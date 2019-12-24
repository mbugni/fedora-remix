# gnome-packages.ks
#
# Defines common packages for the GNOME desktop.

%packages --excludeWeakdeps

# Unwanted stuff
-system-config-printer

PackageKit-gstreamer-plugin
PackageKit-gtk3-module
NetworkManager-l2tp-gnome
NetworkManager-openvpn-gnome
NetworkManager-pptp-gnome
chrome-gnome-shell
dconf
desktop-backgrounds-gnome
evince
evince-nautilus
fedora-release-workstation
file-roller
file-roller-nautilus
firewall-config
gdm
gedit
gnome-bluetooth
gnome-calculator
gnome-characters
gnome-classic-session
gnome-color-manager
gnome-control-center
gnome-font-viewer
gnome-getting-started-docs
gnome-initial-setup
gnome-screenshot
gnome-session-wayland-session
gnome-session-xsession
gnome-settings-daemon
gnome-shell
gnome-software
gnome-system-monitor
gnome-terminal
gnome-terminal-nautilus
gnome-themes-extra
gnome-tweaks
gthumb
nautilus
polkit
yelp
xdg-desktop-portal-gtk
xdg-user-dirs-gtk

# Internet
firefox

# Tools
gparted

%end
