# f28-kde-box.ks
#
# Provides a minimal Linux box based on KDE desktop.

%include f28-kde-base.ks
%include f28-base-remix.ks

%packages --excludeWeakdeps

# Graphics
kamoso
kdegraphics-thumbnailers

# Multimedia
ffmpegthumbs
kio_mtp
vlc

%end
