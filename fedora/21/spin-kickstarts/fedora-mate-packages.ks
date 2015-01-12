%packages
-PackageKit*                # we switched to yumex, so we don't need this
-ConsoleKit                 # ConsoleKit is deprecated
-ConsoleKit-x11             # ConsoleKit is deprecated
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
@libreoffice
@networkmanager-submodules

# FIXME; apparently the glibc maintainers dislike this, but it got put into the
# desktop image at some point.  We won't touch this one for now.
nss-mdns

# This one needs to be kicked out of @standard
-smartmontools
%end
