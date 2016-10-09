## f18-cinnamon-remix.ks

%include f18-cinnamon-desktop.ks
%include f18-base-remix.ks

part / --size 4096 --fstype ext4

%packages

# Graphics
cheese
shotwell
simple-scan

# Internet
icedtea-web
pidgin
transmission-gtk

# Multimedia
brasero
gnash-plugin
rhythmbox
totem
totem-mozplugin

# Office
libreoffice
libreoffice-langpack-it

# Settings
system-config-printer

%end


