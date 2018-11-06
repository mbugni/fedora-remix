# f28-kde-desktop.ks
#
# Provides a complete KDE desktop. Includes office, print and scan support.

%include f28-kde-box.ks
%include f28-base-printing.ks

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

# Printers and scanners
kde-print-manager
skanlite

%end
