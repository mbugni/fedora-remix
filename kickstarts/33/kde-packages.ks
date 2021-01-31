# kde-packages.ks
#
# Defines common packages for the KDE desktop.

%packages --excludeWeakdeps

# Unwanted stuff
-*akonadi*
-kdepim*

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
ibus-qt
kate
kcalc
kcharselect
kcm_systemd
kde-gtk-config
kde-settings-pulseaudio
kde-style-breeze
kdeplasma-addons
kinfocenter
kgamma
konsole5
kscreen
ksysguard
kwalletmanager5
kwin
okular
pam-kwallet
phonon-qt5-backend-gstreamer
plasma-breeze
plasma-desktop
plasma-discover
plasma-discover-flatpak
plasma-discover-notifier
plasma-milou
plasma-nm-l2tp
plasma-nm-openvpn
plasma-nm-pptp
plasma-pa
plasma-user-manager
plasma-workspace
polkit-kde
sddm
sddm-breeze
sddm-kcm
spectacle
svgpart
sweeper
xdg-desktop-portal-kde

# Tools
gparted

%end
