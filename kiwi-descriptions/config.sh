#!/usr/bin/bash

set -euxo pipefail

#======================================
# Functions...
#--------------------------------------
test -f /.kconfig && . /.kconfig
test -f /.profile && . /.profile

#======================================
# Greeting...
#--------------------------------------
echo "Configure image: [$kiwi_iname]-[$kiwi_iversion]..."
echo "Profiles: [$kiwi_profiles]"

#======================================
# Set SELinux booleans
#--------------------------------------
## Fixes KDE Plasma, see rhbz#2058657
setsebool -P selinuxuser_execmod 1

#======================================
# Clear machine specific configuration
#--------------------------------------
## Force generic hostname	
echo "localhost" > /etc/hostname
## Clear machine-id on pre generated images
truncate -s 0 /etc/machine-id

#======================================
# Configure grub correctly
#--------------------------------------
## Works around issues with grub-bls
## See: https://github.com/OSInside/kiwi/issues/2198
echo "GRUB_DEFAULT=saved" >> /etc/default/grub
## Disable submenus to match Fedora
echo "GRUB_DISABLE_SUBMENU=true" >> /etc/default/grub
## Disable recovery entries to match Fedora
echo "GRUB_DISABLE_RECOVERY=true" >> /etc/default/grub

#======================================
# Setup default services
#--------------------------------------
## Enable NetworkManager
systemctl enable NetworkManager.service
## Enable chrony
systemctl enable chronyd.service

#======================================
# Setup default target
#--------------------------------------
if [[ "$kiwi_profiles" == *"Desktop"* ]]; then
	systemctl set-default graphical.target
else
	systemctl set-default multi-user.target
fi

#======================================
# Import GPG keys
#--------------------------------------
releasever=$(rpm --eval '%{fedora}')
rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-fedora-$releasever-primary
# echo "Packages within this disk image"
# rpm -qa --qf '%{size}\t%{name}-%{version}-%{release}.%{arch}\n' | sort -rn

# Note that running rpm recreates the rpm db files which aren't needed or wanted
rm -f /var/lib/rpm/__db*

#======================================
# Remix minimal
#--------------------------------------
if [[ "$kiwi_profiles" == *"Minimal"* ]]; then
	# Delete and lock the root user password
	passwd -d root
	passwd -l root
	# Delete the liveuser user password
	passwd -d liveuser
	usermod -c "Live System User" liveuser
fi

#======================================
# Remix graphical
#--------------------------------------
if [[ "$kiwi_profiles" == *"LiveSystemGraphical"* ]]; then
	echo "Set up desktop ${kiwi_displayname}"
	# Set up default boot theme
	/usr/sbin/plymouth-set-default-theme spinner
	# Enable livesys services
	systemctl enable livesys.service livesys-late.service
	# Set up KDE live session
	echo 'livesys_session="kde"' > /etc/sysconfig/livesys
	# Set up Flatpak
	echo "Setting up Flathub repo..."
	flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
	# Avoid additional Fedora's Flatpak repos
	systemctl disable flatpak-add-fedora-repos
fi

#======================================
# Remix localization
#--------------------------------------
echo "LANG=en_US.UTF-8" > /etc/default/locale
if [[ "$kiwi_profiles" == *"Localization"* ]]; then
	livesys_locale="${kiwi_language}.UTF-8"
	livesys_language="${kiwi_language}"
	livesys_keymap="${kiwi_keytable}"
	echo "Set up language ${livesys_locale}"
	# Setup system-wide locale
	echo "LANG=${livesys_locale}" > /etc/default/locale
	# Replace default locale settings
	sed -i "s/^LANG=.*/LANG=${livesys_locale}/" /etc/xdg/plasma-localerc
	sed -i "s/^LANGUAGE=.*/LANGUAGE="${livesys_language}"/" /etc/xdg/plasma-localerc
	sed -i "s/^defaultLanguage=.*/defaultLanguage=${livesys_language}/" /etc/skel/.config/KDE/Sonnet.conf
	# Store locale config for live scripts
	echo 'livesys_keymap="'$livesys_keymap'"' >> /etc/sysconfig/livesys
fi

#======================================
# Remix	settings
#--------------------------------------
echo "install_weak_deps=False" >> /etc/dnf/dnf.conf

#======================================
# Remix	fixes and tweaks
#--------------------------------------
## Remove preferred browser icon in KDE taskmanager
if [ -f /usr/share/plasma/plasmoids/org.kde.plasma.taskmanager/contents/config/main.xml ]; then
    sed -i -e 's/\,preferred:\/\/browser//' \
    /usr/share/plasma/plasmoids/org.kde.plasma.taskmanager/contents/config/main.xml
fi

exit 0
