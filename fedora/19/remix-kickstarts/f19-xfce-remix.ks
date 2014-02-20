## f19-xfce-remix.ks

%include f19-xfce-desktop.ks
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
clementine
gnash-plugin
vlc
npapi-vlc
xfburn

# Office
@libreoffice
libreoffice-langpack-it

# Printing
cups-pk-helper
system-config-printer

# Tools
tumbler-extras

%end
