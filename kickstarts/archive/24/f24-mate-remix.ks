## f24-mate-remix.ks

%include f24-mate-desktop.ks
%include f24-base-printing.ks
%include f24-base-remix.ks

%packages --excludeWeakdeps

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
ffmpegthumbnailer
gvfs-mtp
rhythmbox
vlc
npapi-vlc

# Office
@libreoffice

# Printing
system-config-printer
system-config-printer-applet

%end
