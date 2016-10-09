%packages
firefox
@mate
compiz
compiz-plugins-main
compiz-plugins-extra
compiz-manager
compizconfig-python
compiz-plugins-unsupported
compiz-mate
libcompizconfig
compiz-plugins-main
ccsm
emerald-themes
emerald
fusion-icon
fusion-icon-gtk
@networkmanager-submodules
blueman

# some apps from mate-applications
# caja-actions
mate-disk-usage-analyzer
mate-netspeed

# more backgrounds
f23-backgrounds-base
f23-backgrounds-mate
f23-backgrounds-extras-base

# system tools
system-config-printer
system-config-printer-applet
lightdm-gtk-greeter-settings

# audio video
parole
exaile
PackageKit-gstreamer-plugin

# office
@libreoffice

# dsl tools
rp-pppoe

# drop packages
-PackageKit*                # we switched to yumex, so we don't need this

# blacklist applications which breaks mate-desktop
-audacious

# FIXME; apparently the glibc maintainers dislike this, but it got put into the
# desktop image at some point.  We won't touch this one for now.
nss-mdns

%end
