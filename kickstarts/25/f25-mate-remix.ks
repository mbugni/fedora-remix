## f25-mate-remix.ks

%include f25-mate-desktop.ks
%include f25-base-printing.ks
%include f25-base-remix.ks

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
