## f21-gnome-remix.ks

%include f21-gnome-desktop.ks
%include f21-base-remix.ks

%packages

# Graphics
cheese
shotwell
simple-scan

# Internet
icedtea-web
empathy
transmission-gtk

# Multimedia
brasero
brasero-nautilus
ffmpegthumbnailer
rhythmbox
totem
totem-nautilus

# Office
@libreoffice
libreoffice-langpack-it

# Printing
system-config-printer

%end
