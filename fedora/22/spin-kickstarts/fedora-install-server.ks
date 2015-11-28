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

# Only uncomment repo commands in one of the two following sections.
# Because the install kickstart doesn't use the updates repo and does 
# use the source repo, we can't just include fedora-repo.ks

# In the master branch the rawhide repo commands should be uncommented.
#repo --name=rawhide --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=rawhide&arch=$basearch --excludepkgs=fedora-productimg-cloud,fedora-productimg-workstation
#repo --name=rawhide-source  --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=rawhide-source&arch=$basearch --excludepkgs=fedora-productimg-cloud,fedora-productimg-workstation

# In non-master branches the fedora repo commands should be uncommented
repo --name=fedora --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=fedora-$releasever&arch=$basearch --excludepkgs=fedora-productimg-cloud,fedora-productimg-workstation
repo --name=fedora-source  --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=fedora-source-$releasever&arch=$basearch --excludepkgs=fedora-productimg-cloud,fedora-productimg-workstation

# Package manifest for the compose.  Uses repo group metadata to translate groups.
# (default groups for the configured repos are added by --default)
# @base got renamed to @standard, but @base is still included by default by pungi.
%packages --default

-fedora-productimg-cloud
fedora-productimg-server
-fedora-productimg-workstation

# pungi is an inclusive depsolver so that multiple packages are brought 
# in to satisify dependencies and we don't always want that. So we  use
# an exclusion list to cut out things we don't want

-kernel*debug*
-kernel-kdump*
-kernel-tools*
-syslog-ng*
-astronomy-bookmarks
-generic-logos*
-generic-release*
-GConf2-dbus*
-bluez-gnome
-community-mysql*

# core
kernel*
dracut-*

# No desktops
-cinnamon*
-enlightenment*
-gnome-shell
-gnome-session
-kde*
-lightdm-kde
-lightdm-razorqt
# Pulls in qt
-oprofile-gui

-@legacy-fonts

-@multimedia

## common stuff
@guest-agents
@standard
@core
@hardware-support

# Fedora Server.
# Including this causes the fedora-release-server package to be included,
# which in turn enables server-product-environment, and due to to its priority
# this will be the default environment.
@^server-product-environment
@server-product
@headless-management
@container-management
@domain-client
@server-hardware-support

# Common server packages
@mysql
@sql-server
@web-server

# Web Server environment
@haproxy
@mongodb
@perl-web
@python-web
@php
@rubyonrails
@tomcat

# Infrastructure Server
@directory-server
@dogtag
@dns-server
@freeipa-server
@ftp-server
@mail-server
@network-server
@printing
@smb-server
@virtualization
@load-balancer
@ha

@javaenterprise

# “uservisible” groups we want to offer
@editors
@network-server
@system-tools
@text-internet

# Things needed for installation
@anaconda-tools
fedora-productimg-server

# Langpacks
autocorr-*
hunspell-*
man-pages-*
-gimp-help-*

# Removals
-PackageKit-zif
-zif
%end
