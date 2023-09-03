# gnome-workstation.ks
#
# Provides a complete GNOME workstation. Includes office, print and scan support.

%include gnome-desktop.ks
%include base-workstation.ks

%packages --excludeWeakdeps

# Bluetooth
gnome-bluetooth

# Connectivity
gnome-shell-extension-gsconnect
gvfs-mtp

# Multimedia
brasero

# Networking
NetworkManager-l2tp-gnome
NetworkManager-openvpn-gnome
NetworkManager-pptp-gnome

# Office
libreoffice-gtk3

# Printers and scanners
simple-scan

%end
