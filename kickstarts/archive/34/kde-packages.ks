# kde-packages.ks
#
# Defines common packages for the KDE desktop.

%packages --excludeWeakdeps

adwaita-gtk2-theme
ark
bluedevil
bluez-hid2hci
bluez-obexd
bluez-tools
breeze-gtk
cagibi
dolphin
fedora-release-kde
gnome-keyring-pam
gwenview
ibus-uniemoji
kate
kcalc
kcharselect
kcm_systemd
kde-gtk-config
# kde-settings-pulseaudio   Fedora is moving to PipeWire
kde-style-breeze
kdeplasma-addons
kinfocenter
kgamma
konsole5
kscreen
# ksysguard                 Replaced by plasma-systemmonitor
kwalletmanager5
kwin
okular
pam-kwallet
# phonon-qt5-backend-gstreamer
plasma-breeze
plasma-desktop
plasma-discover
plasma-discover-flatpak
plasma-discover-notifier
# plasma-discover-offline-updates
plasma-discover-packagekit
plasma-milou
plasma-nm-l2tp
plasma-nm-openvpn
plasma-nm-pptp
plasma-pa
plasma-systemmonitor
plasma-thunderbolt
# plasma-user-manager       Plasma now provides kcm_users
plasma-workspace
plasma-workspace-x11
polkit-kde
sddm
sddm-breeze
sddm-kcm
spectacle
svgpart
sweeper
xdg-desktop-portal-kde

%end
