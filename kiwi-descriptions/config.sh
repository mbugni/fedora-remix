#!/usr/bin/bash

set -euxo pipefail

#======================================
# Greeting...
#--------------------------------------
echo "Configure image: [$kiwi_iname]-[$kiwi_iversion]"
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
# Setup default services
#--------------------------------------
## Enable NetworkManager
systemctl enable NetworkManager.service
## Enable systemd-timesyncd
systemctl enable systemd-timesyncd

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
# Remix livesystem
#--------------------------------------
if [[ "$kiwi_profiles" == *"LiveSystem"* ]]; then
	echo "Delete the root user password"
	passwd -d root
	if [[ "$kiwi_profiles" == *"LiveSystemConsole"* ]]; then
		echo "Delete the liveuser password"
		passwd -d liveuser
		# Set up default boot theme
		/usr/sbin/plymouth-set-default-theme details
	fi
fi

#======================================
# Remix graphical
#--------------------------------------
if [[ "$kiwi_profiles" == *"LiveSystemGraphical"* ]]; then
	echo "Lock the root user account"
	passwd -l root
	# Set up default boot theme
	/usr/sbin/plymouth-set-default-theme spinner
	# Enable livesys session service
	systemctl enable livesys-session.service
	# Enable remix session settings
	systemctl --global enable remix-session.service
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
if [[ "$kiwi_profiles" == *"l10n"* ]]; then
	livesys_locale="${kiwi_language}.UTF-8"
	echo "Set up locale ${livesys_locale}"
	# Setup system-wide locale
	echo "LANG=${livesys_locale}" > /etc/default/locale
	# Setup keyboard layout
	echo "[Layout]" > /etc/xdg/kxkbrc
	echo "LayoutList=${kiwi_keytable}" >> /etc/xdg/kxkbrc
	echo "Use=true" >> /etc/xdg/kxkbrc
	# Replace default locale settings
	sed -i "s/^LANG=.*/LANG=${livesys_locale}/" /etc/xdg/plasma-localerc
	sed -i "s/^LANGUAGE=.*/LANGUAGE="${kiwi_language}"/" /etc/xdg/plasma-localerc
	sed -i "s/^defaultLanguage=.*/defaultLanguage=${kiwi_language}/" /etc/skel/.config/KDE/Sonnet.conf
fi

#======================================
# Remix	settings and tweaks
#--------------------------------------
## Avoid to install weak dependencies
echo "install_weak_deps=False" >> /etc/dnf/dnf.conf
## Enable machine system settings
systemctl enable machine-setup
## Remove preferred browser icon in KDE taskmanager
if [ -f /usr/share/plasma/plasmoids/org.kde.plasma.taskmanager/contents/config/main.xml ]; then
    sed -i -e 's/\,preferred:\/\/browser//' \
    /usr/share/plasma/plasmoids/org.kde.plasma.taskmanager/contents/config/main.xml
fi

exit 0
