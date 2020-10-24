# kde-desktop.ks
#
# Provides a basic Linux box based on KDE desktop.

%include kde-base.ks
%include base-remix.ks

%packages --excludeWeakdeps

# Graphics
kamoso
kdegraphics-thumbnailers

# Multimedia
ffmpegthumbs
kio_mtp
vlc

%end
