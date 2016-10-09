## f23-kde-packages.ks

%packages

# Unwanted stuff
-*akonadi*
-*baloo*
-*nepomuk*
-gnome*
-kdepim*
-system-config-printer

adwaita-gtk2-theme
# apper         FIXME: doesn't work with groups
ark
bluedevil
cagibi
dolphin
firewall-config
gwenview
kate
kcalc
kcharselect
kcm-gtk
kcm_systemd
kcm_touchpad
kde-l10n-Italian
kde-settings-pulseaudio
kde-style-breeze
kdeplasma-addons
kgpg
kinfocenter
kgamma
konsole5
kscreen
ksnapshot
kwalletmanager5
kwin
okular
phonon-backend-gstreamer
plasma-breeze
plasma-desktop
plasma-nm-l2tp
plasma-nm-openvpn
plasma-nm-pptp
# plasma-pk-updates     Updates notification in systray
plasma-workspace
polkit-kde
sddm
sddm-breeze
sddm-kcm
svgpart
sweeper
xsettings-kde
yumex-dnf       # Replace apper and updates notification

# Internet
firefox
thunderbird

# Tools
gparted

%end
