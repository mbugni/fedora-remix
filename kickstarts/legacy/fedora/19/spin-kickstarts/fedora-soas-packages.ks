# fedora-livecd-soas.ks
#
# Description:
# - A Sugar environment that you can carry in your pocket
#
# Maintainers:
# - Peter Robinson <pbrobinson AT gmail DOT com>
# - Sebastian Dziallas <sdz AT fedoraproject DOT org>
# - Mel Chua <mchua AT fedoraproject DOT org>


%packages
-@fonts
-@dial-up
-@multimedia
-@printing
-foomatic
-@gnome-desktop 
-yp-tools
-ypbind
-rdate
-rdist
-icedtea-web
-sendmail
-firefox
-glx-utils
-nmap-ncat
-PackageKit
-libfprint
-realmd
-eekboard-libs
-open-vm-tools*

# == Core Sugar Platform ==
@sugar-desktop
-sugar-ruler
sugar-cp-updater

# Write breaks unless we do this (we don't need it anyway)
# enable for testing in the F17 dev cycle
@input-methods

# == Platform Components ==
# from http://wiki.sugarlabs.org/go/0.94/Platform_Components
alsa-plugins-pulseaudio
alsa-utils
gstreamer1-plugins-base
gstreamer1-plugins-good
gstreamer1-plugins-bad-free
gstreamer-plugins-espeak
pulseaudio
pulseaudio-utils

# explicitly remove openbox and hopefully deal with what firstboot wants
-openbox

# remove deps that come from god knows where
-sane-backends
-sane-backends-drivers-scanners

# Usefulness for DSL connections as per:
# http://bugs.sugarlabs.org/ticket/1951
rp-pppoe
# Useful for SoaS duplication from:
# http://bugs.sugarlabs.org/ticket/74
livecd-tools

# Get the Sugar boot screen
-plymouth-system-theme
-plymouth-theme-charge
sugar-logos

%end
