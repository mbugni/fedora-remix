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
mate-themes-extras

# more backgrounds
f22-backgrounds-mate
f21-backgrounds-extras-base
f21-backgrounds-extras-mate

# system tools
system-config-printer
system-config-printer-applet

# audio player
audacious

# office
@libreoffice

# dsl tools
rp-pppoe

# Drop things for size
-@3d-printing
-brasero
-bluez
-bluez-cups
-colord
-fedora-icon-theme
-GConf2
-gnome-bluetooth-libs
-gnome-icon-theme
-gnome-icon-theme-symbolic
-gnome-software
-gnome-themes
-gnome-themes-standard
-gnome-user-docs

-@mate-applications
-mate-icon-theme-faenza
-NetworkManager-bluetooth

# Drop oversized fonts that aren't needed

# Drop things that pull in perl

# Dictionaries are big
# we're going to try keeping hunspell-* after notting, davidz, and ajax voiced
# strong preference to giving it a go on #fedora-desktop.
# also see http://bugzilla.gnome.org/681084

# Help and art can be big, too
-gnome-user-docs
-evolution-help

# Legacy cmdline things we don't want
-telnet

%end

%post
# This is a huge file and things work ok without it
rm -f /usr/share/icons/HighContrast/icon-theme.cache

%end
