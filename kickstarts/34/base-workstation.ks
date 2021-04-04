# base-workstation.ks
#
# Provides support for office automation. Adds extra repos for print drivers.

%packages --excludeWeakdeps

# Fonts
wine-fonts

# Graphics
sane-backends-drivers-cameras
sane-backends-drivers-scanners

# Internet
thunderbird

# Printing
@printing
cups-ipptool
cups-lpd

# Office
libreoffice-calc
libreoffice-impress
libreoffice-writer

%end


%post

echo ""
echo "POST BASE WORKSTATION ********************************"
echo ""

# Link Wine fonts to system folder
ln -s /usr/share/wine/fonts /usr/share/fonts/wine

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

%end
