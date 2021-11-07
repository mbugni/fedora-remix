# xfce-packages.ks
#
# Defines common packages for the XFCE desktop.

%packages --excludeWeakdeps

NetworkManager-l2tp-gnome
NetworkManager-openvpn-gnome
NetworkManager-pptp-gnome
Thunar
adwaita-gtk2-theme
adwaita-icon-theme
alsa-utils
blueman
fedora-release-xfce
galculator
gnome-icon-theme-legacy
gnome-keyring-pam
gthumb
gtk-murrine-engine  # Needed by materia-gtk-theme
gvfs
gvfs-archive
lightdm-gtk
materia-gtk-theme
mousepad
network-manager-applet
nm-connection-editor
pavucontrol
# ristretto     # Too simple
thunar-archive-plugin
thunar-media-tags-plugin
thunar-volman
thunderbird
tumbler
xarchiver
xdg-desktop-portal
xdg-user-dirs-gtk
xfce4-about
xfce4-appfinder
xfce4-clipman-plugin
xfce4-datetime-plugin
xfce4-notifyd
xfce4-panel
xfce4-places-plugin
xfce4-power-manager
xfce4-pulseaudio-plugin
xfce4-screensaver
xfce4-screenshooter-plugin
xfce4-session
xfce4-settings
xfce4-statusnotifier-plugin
xfce4-taskmanager
xfce4-terminal
xfce4-verve-plugin
xfce4-whiskermenu-plugin
xfconf
xfdesktop
xfpanel-switch
xfwm4
zathura-plugins-all

# Tools
gparted

%end
