# gnome-desktop.ks
#
# Provides a complete GNOME desktop. Includes office, print and scan support.

%include gnome-box.ks
%include base-printing.ks

%packages --excludeWeakdeps

# Graphics
sane-backends-drivers-cameras
sane-backends-drivers-scanners

# Internet
thunderbird

# Multimedia
brasero
brasero-nautilus

# Office
@libreoffice
libreoffice-gtk3
java-1.8.0-openjdk-headless     # Force Java 1.8 dependency for L.Office

# Printers and scanners
simple-scan

%end
