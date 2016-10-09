# fedora-livecd-kde.ks
#
# Description:
# - Fedora Live Spin with the K Desktop Environment (KDE), default 1.4 GB version
#
# Maintainer(s):
# - Sebastian Vahl <fedora@deadbabylon.de>
# - Fedora KDE SIG, http://fedoraproject.org/wiki/SIGs/KDE, kde@lists.fedoraproject.org

%include fedora-live-kde-base.ks
%include fedora-live-minimization.ks

# DVD payload
part / --size=6144


%packages
# unwanted packages from @kde-desktop
# don't include these for now to fit on a cd
-desktop-backgrounds-basic
-kdeaccessibility*
-kdeartwork-screensavers	# screensavers are not needed on live images
#-ktorrent			# kget has also basic torrent features (~3 megs)
-digikam			# digikam has duplicate functionality with gwenview (~28 megs)
#-amarok 			# ~23 megs (mysql-embedded etc.)
-kipi-plugins			# ~8 megs + drags in Marble
#-kdeplasma-addons		# ~16 megs
#-krusader			# ~4 megs

# Additional packages that are not default in kde-* groups, but useful
k3b				# ~15 megs
#kdeartwork			# only include some parts of kdeartwork
fuse
liveusb-creator

# only include kdegames-minimal
-kdegames
kdegames-minimal

### space issues

# fonts (we make no bones about admitting we're english-only)
wqy-microhei-fonts			# a compact CJK font, to replace:
-naver-nanum-gothic-fonts		# Korean
-vlgothic-fonts				# Japanese
-adobe-source-han-sans-cn-fonts		# simplified Chinese
-adobe-source-han-sans-twhk-fonts	# traditional Chinese

-paratype-pt-sans-fonts	# Cyrillic (already supported by DejaVu), huge
#-stix-fonts		# mathematical symbols

# remove input methods to free space
-@input-methods
-scim*
-m17n*
-ibus*
-iok

# save some space (from @standard)
-make

# admin-tools
-gnome-disk-utility
# kcm_clock still lacks some features, so keep system-config-date around
#-system-config-date
# prefer kcm_systemd
-system-config-services
# prefer/use kusers
-system-config-users

## avoid serious bugs by omitting broken stuff

%end

%post
%end
