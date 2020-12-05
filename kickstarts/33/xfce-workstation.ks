# xfce-workstation.ks
#
# Provides a complete XFCE workstation. Includes office, print and scan support.

%include xfce-desktop.ks
%include base-workstation.ks

%packages --excludeWeakdeps

# Multimedia
xfburn

# Office
libreoffice-gtk3

# Printers and scanners
xsane
system-config-printer
system-config-printer-applet

%end
