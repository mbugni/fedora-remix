# kde-desktop.ks
#
# Provides a complete KDE desktop. Includes office, print and scan support.

%include kde-box.ks
%include base-printing.ks

%packages --excludeWeakdeps

# Graphics
sane-backends-drivers-cameras
sane-backends-drivers-scanners

# Internet
ktorrent
thunderbird

# Multimedia
clementine
k3b
k3b-extras-freeworld

# Office
@libreoffice
libreoffice-gtk3
java-1.8.0-openjdk-headless     # Force Java 1.8 dependency for L.Office

# Printers and scanners
kde-print-manager
skanlite

%end
