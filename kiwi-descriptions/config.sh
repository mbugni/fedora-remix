#!/usr/bin/bash

set -euxo pipefail

#======================================
# Greeting...
#--------------------------------------
echo "Configure image: $kiwi_iname-$kiwi_iversion"
echo "Profiles: [$kiwi_profiles]"

#======================================
# Set SELinux booleans
#--------------------------------------
## Fixes KDE Plasma, see rhbz#2058657
setsebool -P selinuxuser_execmod 1

#======================================
# Setup machine specific configuration
#--------------------------------------
## Setup hostname	
echo "${kiwi_iname,,}" > /etc/hostname
## Clear machine-id on pre generated images
truncate -s 0 /etc/machine-id

#======================================
# Setup default services
#--------------------------------------
## Enable NetworkManager
systemctl enable NetworkManager.service
## Enable Network Time Protocol
systemctl enable systemd-timesyncd

#======================================
# Import GPG keys
#--------------------------------------
releasever=$(rpm --eval '%{fedora}')
rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-fedora-$releasever-primary

#======================================
# Setup live system
#--------------------------------------
echo 'Delete the root user password'
passwd -d root
echo 'Lock the root user account'
passwd -l root
echo 'Enable livesys session'
systemctl enable livesys-boot-setup.service
plymouth_theme="details"
if [[ "$kiwi_profiles" == *"LiveSystemGraphical"* ]]; then
	# Setup graphical system
	systemctl set-default graphical.target
	# Setup graphical boot theme
	plymouth_theme="bgrt"
	# Enable user session setup
	systemctl --global enable remix-session-setup.service
	# Set up Flatpak
	echo "Setting up Flathub repo..."
	flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
	# Avoid additional Fedora's Flatpak repos
	systemctl disable flatpak-add-fedora-repos
else
	# Fallback to console system
	systemctl set-default multi-user.target
fi
# Setup default boot theme
/usr/sbin/plymouth-set-default-theme "${plymouth_theme}"

#======================================
# Setup localization
#--------------------------------------
echo "LANG=en_US.UTF-8" > /etc/default/locale
if [[ "$kiwi_profiles" == *"l10n"* ]]; then
	system_locale="${kiwi_language}.UTF-8"
	echo "Set up locale ${system_locale}"
	# Setup system-wide locale
	echo "LANG=${system_locale}" > /etc/default/locale
	# Setup keyboard layout
	echo "[Layout]" > /etc/xdg/kxkbrc
	echo "LayoutList=${kiwi_keytable}" >> /etc/xdg/kxkbrc
	echo "Use=true" >> /etc/xdg/kxkbrc
fi

#======================================
# Additional settings and tweaks
#--------------------------------------
## Avoid to install weak dependencies
echo "install_weak_deps=False" >> /etc/dnf/dnf.conf
## Enable system wide settings
systemctl enable remix-system-setup.service

#======================================
# System clean
#--------------------------------------
## Running rpm recreates the rpm db files which aren't needed or wanted
rm -f /var/lib/rpm/__db*

exit 0
