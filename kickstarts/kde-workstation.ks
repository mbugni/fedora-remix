# kde-workstation.ks
#
# Provides a complete KDE workstation. Includes office, print and scan support.

%include kde-desktop.ks
%include base-workstation.ks

%packages --excludeWeakdeps

# Bluetooth
bluedevil
bluez-hid2hci
bluez-obexd
bluez-tools

# Connectivity
kde-connect
kio_mtp

# Multimedia
k3b

# Networking
plasma-nm-l2tp
plasma-nm-openvpn
plasma-nm-pptp

# Office
libreoffice-kf5

# Printers and scanners
kde-print-manager
skanlite

# Software
flatpak-kcm

%end
