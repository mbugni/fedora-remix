# Kickstart file for composing the "Fedora Cloud" spin of Fedora (rawhide)
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
#repo --name=rawhide --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=rawhide&arch=$basearch --excludepkgs=fedora-productimg-workstation,fedora-productimg-server
#repo --name=rawhide-source --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=rawhide-source&arch=$basearch --excludepkgs=fedora-productimg-workstation,fedora-productimg-server

# In non-master branches the fedora repo commands should be uncommented
repo --name=fedora --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=fedora-$releasever&arch=$basearch --excludepkgs=fedora-productimg-workstation,fedora-productimg-server
repo --name=fedora-source --mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=fedora-source-$releasever&arch=$basearch --excludepkgs=fedora-productimg-workstation,fedora-productimg-server

# Package manifest for the compose.  Uses repo group metadata to translate groups.
# (default groups for the configured repos are added by --default)
# @base got renamed to @standard, but @base is still included by default by pungi.
%packages --default

# pungi is an inclusive depsolver so that multiple packages are brought 
# in to satisify dependencies and we don't always want that. So we  use
# an exclusion list to cut out things we don't want

-kernel*debug*
-kernel-kdump*
-kernel-tools*
-syslog-ng*
-astronomy-bookmarks
# generic* would match generic-jms-ra, so don't 'simplify' this
-generic-logos*
-generic-release*
-GConf2-dbus*
-bluez-gnome
-community-mysql*
# jruby used to be in this list, but springframework-context explicitly
# requires it, not just 'any ruby implemention' - please check for things
# on the image that require mvn(org.jruby:jruby) before adding jruby to
# this list again - adamw 2014/09
#-jruby

# core
kernel*
dracut-*


# Things needed for installation
@anaconda-tools
fedora-productimg-cloud
-fedora-productimg-server
-fedora-productimg-workstation

# Packages to enable server images to run in cloud environments
@cloud-server
@core
@standard
@headless-management
@dogtag
@directory-server
@dns-server
@freeipa-server
@ftp-server
@guest-agents
@ha
@load-balancer
@mail-server
@mysql
@network-server
@smb-server
@sql-server
@web-server

# Langpacks
autocorr-*
hunspell-*
hyphen-*
man-pages-*
-gimp-help-*

# Removals
-PackageKit-zif
-zif
%end
