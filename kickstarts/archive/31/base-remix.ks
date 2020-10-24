# base-remix.ks
#
# Adds extra repos for software that the Fedora Project doesn't want to ship.

# Extra repositories
repo --name=rpmfusion-free --mirrorlist=http://mirrors.rpmfusion.org/mirrorlist?repo=free-fedora-$releasever&arch=$basearch
repo --name=rpmfusion-free-updates --mirrorlist=http://mirrors.rpmfusion.org/mirrorlist?repo=free-fedora-updates-released-$releasever&arch=$basearch
repo --name=rpmfusion-nonfree --mirrorlist=http://mirrors.rpmfusion.org/mirrorlist?repo=nonfree-fedora-$releasever&arch=$basearch
repo --name=rpmfusion-nonfree-updates --mirrorlist=http://mirrors.rpmfusion.org/mirrorlist?repo=nonfree-fedora-updates-released-$releasever&arch=$basearch
repo --name=rpmfusion-free-release-tainted --metalink=https://mirrors.rpmfusion.org/metalink?repo=free-fedora-tainted-$releasever&arch=$basearch

%packages --excludeWeakdeps

# RPM Fusion repositories
rpmfusion-free-release
rpmfusion-free-release-tainted
rpmfusion-nonfree-release
rpmfusion-nonfree-release-tainted

# Appstream data
rpmfusion-*-appstream-data

# Multimedia
gstreamer*-libav
gstreamer*-vaapi
gstreamer*-plugins-bad-free
gstreamer*-plugins-bad-freeworld
gstreamer*-plugins-good
gstreamer*-plugins-ugly
gstreamer*-plugins-ugly-free
libdvdcss

# Tools
exfat-utils
fuse-exfat
unrar

%end
