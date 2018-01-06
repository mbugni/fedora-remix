## f25-kde-remix.ks

%include f25-kde-desktop.ks
%include f25-base-printing.ks
%include f25-base-remix.ks

%packages --excludeWeakdeps

# Graphics
digikam
# guvcview
kamoso
kdegraphics-thumbnailers
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

# Printing
kde-print-manager

%end
