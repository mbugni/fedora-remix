# base-flatpak.ks
#
# Defines the basics for a basic flatpak environment.

%packages --excludeWeakdeps

# Fonts
libreoffice-opensymbol-fonts

# Software
flatpak

%end

%post

echo ""
echo "POST BASE FLATPAK ************************************"
echo ""

%end

# Enable DNS resolution
# See: https://anaconda-installer.readthedocs.io/en/latest/common-bugs.html#network-issues
%post --nochroot
cat /etc/resolv.conf > /mnt/sysimage/etc/resolv.conf
%end

# Manage flatpak setup
%post

# Manage flatpak repos
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Workaround permission for error during flatpak install:
# bwrap: No permissions to creating new namespace, likely because the kernel does not allow non-privileged user namespaces
chmod u+s /usr/bin/bwrap

# Install Firefox
flatpak install --noninteractive --assumeyes flathub org.mozilla.firefox

# Restore workaround permission
chmod u-s /usr/bin/bwrap

# Restore DNS resolution
rm /etc/resolv.conf

%end
