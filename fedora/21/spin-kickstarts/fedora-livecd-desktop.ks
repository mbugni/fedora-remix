# Desktop with customizations to fit in a CD (package removals, etc.)
# Maintained by the Fedora Desktop SIG:
# http://fedoraproject.org/wiki/SIGs/Desktop
# mailto:desktop@lists.fedoraproject.org

%include fedora-live-desktop.ks
%include fedora-live-minimization.ks

%packages
# reduce the office suite in size
-planner
-libreoffice-xsltfilter
-libreoffice-pyuno
-libreoffice-emailmerge
-libreoffice-math

# remove some other applications
-gnome-boxes
-gnome-dictionary

# remove input method things we don't need
-ibus-typing-booster
-imsettings
-imsettings-gsettings

# Drop the Java plugin
-icedtea-web
-java-1.8.0-openjdk

# Drop things that pull in perl
-linux-atm

# No printing
-foomatic-db-ppds
-foomatic

# we don't want prelink
-prelink

# Dictionaries are big
# we're going to try keeping hunspell-* after notting, davidz, and ajax voiced
# strong preference to giving it a go on #fedora-desktop.
# also see http://bugzilla.gnome.org/681084
-aspell-*
-man-pages*
-words

# Help and art and fonts can be big, too
-evolution-help
-desktop-backgrounds-basic
-*backgrounds-extras
-stix-fonts

# Legacy and cmdline things we don't want
-krb5-auth-dialog
-krb5-workstation
-pam_krb5
-quota
-nano
-minicom
-dos2unix
-finger
-ftp
-jwhois
-mtr
-pinfo
-rsh
-telnet
-nfs-utils
-ypbind
-yp-tools
-rpcbind
-acpid
-ntsysv
-rmt
-talk
-lftp
-tcpdump
-dump

# Drop some system-config things
-system-config-language
-system-config-rootpassword
-system-config-services
-policycoreutils-gui

# These things are cut purely for space reasons
-aisleriot
-brasero
-brasero-nautilus
-bijiben
-gnome-system-log
-deja-dup
-eog
-gnu-free-mono-fonts
-gnu-free-sans-fonts
-gnu-free-serif-fonts
-uboot-tools
-dtc

# Without gnu freefonts, the lack of Malayalam coverage is
# a problem in anaconda (#977764)
lohit-malayalam-fonts

%end

%post

# This is a huge file and things work ok without it
rm -f /usr/share/icons/HighContrast/icon-theme.cache

%end
