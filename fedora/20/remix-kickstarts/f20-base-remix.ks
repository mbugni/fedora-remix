## f20-base-remix.ks

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

# @printing
bluez-cups
cups
cups-filters
ghostscript
foomatic
foomatic-db-ppds
foomatic-filters
gutenprint
gutenprint-cups
hpijs
hplip
mpage
paps
samba-client

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

# Enable wheel group as administrator for print server (rhb #907595)
sed -i 's/^SystemGroup /SystemGroup wheel /g' /etc/cups/cups-files.conf

# OpenPrinting/Database/DriverPackages based on the LSB 3.2
cat > /etc/yum.repos.d/openprinting-drivers.repo << OPENPRINTING_REPO_EOF
[openprinting-drivers-main]
name=OpenPrinting LSB-based driver - main
baseurl=http://www.openprinting.org/download/printdriver/components/lsb3.2/main/RPMS
enabled=1
gpgcheck=0
timeout=5
skip_if_unavailable=True

[openprinting-drivers-contrib]
name=OpenPrinting LSB-based driver - contrib
baseurl=http://www.openprinting.org/download/printdriver/components/lsb3.2/contrib/RPMS
enabled=1
gpgcheck=0
timeout=5
skip_if_unavailable=True

[openprinting-drivers-lsbddk]
name=OpenPrinting LSB-based driver - lsbddk
baseurl=http://www.openprinting.org/download/printdriver/components/lsb3.2/lsbddk/RPMS
enabled=1
gpgcheck=0
timeout=5
skip_if_unavailable=True

[openprinting-drivers-main-nonfree]
name=OpenPrinting LSB-based driver packages - main-nonfree
baseurl=http://www.openprinting.org/download/printdriver/components/lsb3.2/main-nonfree/RPMS
enabled=1
gpgcheck=0
timeout=5
skip_if_unavailable=True
OPENPRINTING_REPO_EOF

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

