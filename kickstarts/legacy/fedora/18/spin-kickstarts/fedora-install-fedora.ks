# Kickstart file for composing the "Fedora" spin of Fedora (rawhide)
# Maintained by the Fedora Release Engineering team:
# https://fedoraproject.org/wiki/ReleaseEngineering
# mailto:rel-eng@lists.fedoraproject.org

# Use a part of 'iso' to define how large you want your isos.
# Only used when composing to more than one iso.
# Default is 695 (megs), CD size.
# Listed below is the size of a DVD if you wanted to split higher.
#part iso --size=4998

# Add the repos you wish to use to compose here.  At least one of them needs group data.
repo --name=fedora --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=fedora-$releasever&arch=$basearch --exclude kernel*debug* --exclude kernel-kdump* --exclude kernel-tools* --exclude syslog-ng* --exclude astronomy-bookmarks --exclude generic* --exclude btanks* --exclude mate-* --exclude imsettings-mate
repo --name=fedora-source  --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=fedora-source-$releasever&arch=$basearch --exclude kernel*debug* --exclude kernel-kdump* --exclude kernel-tools* --exclude syslog-ng* --exclude astronomy-bookmarks --exclude generic* --exclude btanks* --exclude mate-*


# Package manifest for the compose.  Uses repo group metadata to translate groups.
# (default groups for the configured repos are added by --default)
%packages --default
# core
kernel*
-kernel-tools*
-kernel-debug*
dracut-*

# Desktops

## common stuff
@base-x
@standard
@core
@dial-up
@fonts
@input-methods
@multimedia
@hardware-support
@printing

## GNOME
@firefox
@gnome-desktop
@epiphany
@libreoffice
@gnome-games

## KDE
@kde-desktop
@kde-apps
@kde-education
@kde-media
@kde-office

## XFCE
@xfce-desktop
@xfce-apps
@xfce-extra-plugins
@xfce-media
@xfce-office

## LXDE
@lxde-desktop
@lxde-apps
@lxde-media
@lxde-office

## SUGAR
@sugar-desktop
@sugar-apps

# Web server
@web-server
@haproxy
@jbossas
@mongodb
@perl-web
@python-web
@php
@rubyonrails
@mysql
@sql-server

# Infrastructure server
@dns-server
@ftp-server
@mail-server
@network-server
@smb-server

# Workstation
@eclipse
@development-libs
@development-tools
@fedora-packager
@gnome-software-development
@kde-software-development
@x-software-development
@virtualization
@web-server
@jbossas
@mongodb
@perl-web
@php
@rubyonrails
@mysql
@sql-server
@design-suite
## Not included yet due to space concerns
#@milkymist
#@mingw32
#@ocaml
#@robotics-suite
#@electronic-lab

# Things needed for installation
@anaconda-tools

# Langpacks
aspell-*
autocorr-*
eclipse-nls-*
hunspell-*
hyphen-*
calligra-l10n-*
kde-l10n-*
kde-i18n-*
libreoffice-langpack-*
man-pages-*
mythes-*

# Removals
-PackageKit-zif
-zif
%end
