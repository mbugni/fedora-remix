#!/bin/bash

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
## Enable SSH
systemctl enable sshd.service
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
fi

#======================================
# Remix localization
#--------------------------------------
if [[ "$kiwi_profiles" == *"Localization"* ]]; then
	livesys_locale="$(/bin/bash -c 'source /etc/locale.conf && echo $LANG')"
	livesys_language="$(echo $livesys_locale | head -c 5)"
	livesys_keymap="$(echo $livesys_locale | head -c 2)"
	echo "Set up language ${livesys_locale}"
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

exit 0
