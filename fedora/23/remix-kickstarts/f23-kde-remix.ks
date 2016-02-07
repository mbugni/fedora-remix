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
vlc
npapi-vlc

# Office
@libreoffice
libreoffice-langpack-it

# Settings
kde-print-manager

%end
