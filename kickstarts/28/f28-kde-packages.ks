# f28-kde-packages.ks
#
# Defines common packages for the KDE desktop.

%packages --excludeWeakdeps

# Unwanted stuff
-*akonadi*
-*baloo*
-gnome*
-kdepim*
-system-config-printer

adwaita-gtk2-theme
ark
bluedevil
bluez-hid2hci
bluez-obexd
bluez-tools
breeze-gtk
cagibi
dolphin
firewall-config
gnome-keyring-pam
gwenview
kate
kcalc
kcharselect
kcm_systemd
kcm_touchpad
kde-gtk-config
kde-settings-pulseaudio
kde-style-breeze
kdeplasma-addons
# kgpg
kinfocenter
kgamma
konsole5
kscreen
ksysguard
kwalletmanager5
kwin
okular
phonon-backend-gstreamer
plasma-breeze
plasma-desktop
plasma-discover
plasma-discover-flatpak
plasma-discover-notifier
plasma-nm-l2tp
plasma-nm-openvpn
plasma-nm-pptp
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

# Internet
firefox

# Tools
gparted

%end
