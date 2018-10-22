## f26-kde-remix.ks

%include f26-kde-desktop.ks
%include f26-base-printing.ks
%include f26-base-remix.ks

%packages --excludeWeakdeps

# Graphics
digikam
kamoso
kdegraphics-thumbnailers
skanlite

# Internet
icedtea-web
ktorrent

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
