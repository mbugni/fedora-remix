# gnome-workstation.ks
#
# Provides a complete GNOME workstation. Includes office, print and scan support.

%include gnome-desktop.ks
%include base-workstation.ks

%packages --excludeWeakdeps

# Qt support for GNOME
qgnomeplatform

# Multimedia
brasero
brasero-nautilus
vlc

# Printers and scanners
simple-scan

%end
