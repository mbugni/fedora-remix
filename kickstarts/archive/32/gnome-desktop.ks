# gnome-desktop.ks
#
# Provides a basic Linux box based on GNOME desktop.

%include gnome-base.ks
%include base-remix.ks

%packages --excludeWeakdeps

# Graphics
cheese

# Multimedia
gvfs-mtp
nautilus-extensions
totem
sushi

%end
