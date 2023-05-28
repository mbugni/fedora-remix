# base-extras.ks
#
# Adds extra components that the Fedora Project doesn't want to ship.

# Extra repositories
repo --name=rpmfusion-free --metalink=https://mirrors.rpmfusion.org/metalink?repo=free-fedora-$releasever&arch=$basearch
repo --name=rpmfusion-free-updates --metalink=https://mirrors.rpmfusion.org/metalink?repo=free-fedora-updates-released-$releasever&arch=$basearch
repo --name=rpmfusion-nonfree --metalink=https://mirrors.rpmfusion.org/metalink?repo=nonfree-fedora-$releasever&arch=$basearch
repo --name=rpmfusion-nonfree-updates --metalink=https://mirrors.rpmfusion.org/metalink?repo=nonfree-fedora-updates-released-$releasever&arch=$basearch
repo --name=rpmfusion-free-tainted --metalink=https://mirrors.rpmfusion.org/metalink?repo=free-fedora-tainted-$releasever&arch=$basearch
repo --name=rpmfusion-nonfree-tainted --metalink=https://mirrors.rpmfusion.org/metalink?repo=nonfree-fedora-tainted-$releasever&arch=$basearch

%packages --excludeWeakdeps

# RPM Fusion repositories
rpmfusion-free-release
rpmfusion-free-release-tainted
rpmfusion-nonfree-release
rpmfusion-nonfree-release-tainted

# Appstream data
rpmfusion-*-appstream-data

# Multimedia
ffmpeg
gstreamer1-vaapi
gstreamer1-plugins-bad-freeworld
gstreamer1-plugins-ugly
intel-media-driver
libdvdcss
mesa-va-drivers-freeworld
mesa-vdpau-drivers-freeworld

# Tools
unrar

%end
