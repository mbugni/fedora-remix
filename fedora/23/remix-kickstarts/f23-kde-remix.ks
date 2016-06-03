## f23-kde-remix.ks

%include f23-kde-desktop.ks
%include f23-base-remix.ks

%packages

# Unwanted stuff
-libreoffice-kde

# Graphics
digikam
guvcview
# kamera
kdegraphics-thumbnailers
kwebkitpart
skanlite

# Internet
icedtea-web
ktorrent
pidgin

# Multimedia
clementine
ffmpegthumbs
k3b
k3b-extras-freeworld
kio_mtp
vlc
npapi-vlc

# Office
@libreoffice
libreoffice-langpack-it

# Printing
kde-print-manager

%end
