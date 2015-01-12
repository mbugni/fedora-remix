# Desktop with customizations to fit in a CD (package removals, etc.)
# Maintained by the Fedora Desktop SIG:
# http://fedoraproject.org/wiki/SIGs/Desktop
# mailto:desktop@lists.fedoraproject.org

%include fedora-live-mate_compiz.ks
%include fedora-live-minimization.ks

%packages

# some apps from mate-applications
caja-actions
mate-disk-usage-analyzer
mate-netspeed

# system tools
system-config-printer
system-config-printer-applet


# audio player
audacious

# First, no office
-planner

# Drop things for size
-@3d-printing
-brasero
-bluez
-bluez-cups
-colord
-@dial-up
-espeak
-fedora-icon-theme
-GConf2
-gnome-bluetooth-libs
-gnome-icon-theme
-gnome-icon-theme-symbolic
-gnome-software
-gnome-themes
-gnome-user-docs
-gstreamer1-plugins-good
-gstreamer1-plugins-bad-free
-gstreamer-plugins-good
-gstreamer-plugins-bad-free
-gstreamer-plugins-espeak
-@guest-desktop-agents
-@libreoffice
-@mate-applications
-mate-icon-theme-faenza
-NetworkManager-bluetooth
-samba-client
-ibus-chewing
-libical
-OpenEXR-libs

# Drop oversized fonts that aren't needed
-gnu-free-mono-fonts
-gnu-free-fonts-common
-gnu-free-serif-fonts
-gnu-free-sans-fonts
-stix-fonts

# Drop the Java plugin
-icedtea-web
-java-1.8.0-openjdk

# Drop things that pull in perl
-linux-atm

# Dictionaries are big
# we're going to try keeping hunspell-* after notting, davidz, and ajax voiced
# strong preference to giving it a go on #fedora-desktop.
# also see http://bugzilla.gnome.org/681084
-aspell-*
-man-pages*
-words

# Help and art can be big, too
-gnome-user-docs
-evolution-help
-desktop-backgrounds-basic
-*backgrounds-extras

# Legacy cmdline things we don't want
-krb5-auth-dialog
-krb5-workstation
-pam_krb5

-minicom

-jwhois
-mtr
-pinfo
-rsh
-ypbind
-yp-tools
-ntsysv

# Drop some system-config things
-system-config-rootpassword
-system-config-services
-policycoreutils-gui

%end

%post
# This is a huge file and things work ok without it
rm -f /usr/share/icons/HighContrast/icon-theme.cache

%end
