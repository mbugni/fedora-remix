## f18-cinnamon-remix.ks

%include f19-cinnamon-desktop.ks
%include f19-base-remix.ks

part / --size 4096 --fstype ext4

%packages

# Graphics
guvcview
shotwell
simple-scan

# Internet
icedtea-web
pidgin
transmission-gtk

# Multimedia
brasero
clementine
ffmpegthumbnailer
gnash-plugin
vlc
npapi-vlc

# Office
@libreoffice
libreoffice-langpack-it

# Printing
system-config-printer

%end
