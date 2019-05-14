## f27-kde-box.ks

%include f27-kde-base.ks
%include f27-base-remix.ks

%packages --excludeWeakdeps

# Graphics
kamoso
kdegraphics-thumbnailers

# Multimedia
ffmpegthumbs
kio_mtp
vlc
npapi-vlc

%end
