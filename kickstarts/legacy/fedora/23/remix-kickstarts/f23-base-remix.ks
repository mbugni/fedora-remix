## f23-base-remix.ks

# Extra repositories
repo --name=rpmfusion-free --mirrorlist=http://mirrors.rpmfusion.org/mirrorlist?repo=free-fedora-$releasever&arch=$basearch
repo --name=rpmfusion-free-updates --mirrorlist=http://mirrors.rpmfusion.org/mirrorlist?repo=free-fedora-updates-released-$releasever&arch=$basearch
repo --name=rpmfusion-nonfree --mirrorlist=http://mirrors.rpmfusion.org/mirrorlist?repo=nonfree-fedora-$releasever&arch=$basearch
repo --name=rpmfusion-nonfree-updates --mirrorlist=http://mirrors.rpmfusion.org/mirrorlist?repo=nonfree-fedora-updates-released-$releasever&arch=$basearch
repo --name=remi --includepkgs=libdvd*,remi-release* --baseurl=http://rpms.famillecollet.com/fedora/$releasever/remi/$basearch/

%packages

# RPM Fusion repositories
rpmfusion-free-release
rpmfusion-nonfree-release

# Remi repositories (disabled)
remi-release

# @multimedia
PackageKit-gstreamer-plugin
gstreamer-plugins-bad-free
gstreamer-plugins-good

# Graphics
sane-backends-drivers-cameras
sane-backends-drivers-scanners

# Multimedia
gstreamer-ffmpeg
gstreamer*-libav
gstreamer*-vaapi
gstreamer*-plugins-bad
gstreamer*-plugins-bad-*free
gstreamer*-plugins-bad-freeworld
gstreamer*-plugins-good
gstreamer*-plugins-ugly
libdvdcss

# Tools
unrar

%end


%post

echo ""
echo "***************"
echo "POST BASE REMIX"
echo "***************"

# A reduced version of Remi repository
cat > /etc/yum.repos.d/remix.repo << REMI_REPO_EOF
[remix-remi]
name=Remix Remi - Fedora \$releasever - \$basearch
#baseurl=http://rpms.famillecollet.com/fedora/\$releasever/remi/\$basearch/
mirrorlist=http://rpms.famillecollet.com/fedora/\$releasever/remi/mirror
enabled=1
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-remi
timeout=5
includepkgs=libdvd*,remi-release*
REMI_REPO_EOF

%end
