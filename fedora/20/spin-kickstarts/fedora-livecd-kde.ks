# fedora-livecd-kde.ks
#
# Description:
# - Fedora Live Spin with the K Desktop Environment (KDE), default 1 GiB version
#
# Maintainer(s):
# - Sebastian Vahl <fedora@deadbabylon.de>
# - Fedora KDE SIG, http://fedoraproject.org/wiki/SIGs/KDE, kde@lists.fedoraproject.org

%include fedora-live-kde-base.ks
%include fedora-live-minimization.ks

# DVD payload
part / --size=4096


%packages
# unwanted packages from @kde-desktop
# don't include these for now to fit on a cd
-desktop-backgrounds-basic
-kdeaccessibility*
-scribus			# scribus is too big for the live images
-kdeartwork-screensavers	# screensavers are not needed on live images
#-ktorrent			# kget has also basic torrent features (~3 megs)
-digikam			# digikam has duplicate functionality with gwenview (~28 megs)
#-amarok 			# ~23 megs (mysql-embedded etc.)
-kipi-plugins			# ~8 megs + drags in Marble
#-kdeplasma-addons		# ~16 megs
#-krusader			# ~4 megs

# Additional packages that are not default in kde-desktop but useful
k3b				# ~15 megs
-calligra			# don't include whole calligra, just parts of it
calligra-words
calligra-sheets			# ~1 megs
calligra-stage			# ~3 megs
#kdeartwork			# only include some parts of kdeartwork
#twinkle			# (~10 megs)
fuse
liveusb-creator

# only include kdegames-minimal
-kdegames
kdegames-minimal

### space issues

# fonts (we make no bones about admitting we're english-only)
wqy-microhei-fonts	# a compact CJK font, to replace:
-nhn-nanum-gothic-fonts	# Korean
-vlgothic-fonts		# Japanese
-wqy-zenhei-fonts	# simplified Chinese
-cjkuni-uming-fonts	# traditional Chinese

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

# save space (it pulls in gdisk/udisks2/libicu)
-gnome-disk-utility

## avoid serious bugs by omitting broken stuff

%end

%post
%end
