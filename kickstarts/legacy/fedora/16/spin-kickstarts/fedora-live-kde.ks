# fedora-live-kde.ks
#
# Description:
# - Fedora Live Spin with the K Desktop Environment (KDE), 2 GiB version
#   see fedora-livecd-kde.ks for the default CD-sized version
#
# Maintainer(s):
# - Sebastian Vahl <fedora@deadbabylon.de>
# - Fedora KDE SIG, http://fedoraproject.org/wiki/SIGs/KDE, kde@lists.fedoraproject.org

%include fedora-live-kde-base.ks
%include fedora-live-minimization.ks

# DVD payload
part / --size=8192


%packages
# ship KDE wallpapers instead of GNOME ones
-desktop-backgrounds-basic
kde-wallpapers

# Additional packages that are not default in kde-desktop but useful
k3b				# ~15 megs
koffice-suite
#kdeartwork			# only include some parts of kdeartwork
#twinkle			# (~10 megs)
fuse
liveusb-creator
#pavucontrol			# pavucontrol has duplicate functionality with kmix
#kaffeine*			# kaffeine has duplicate functionality with dragonplayer (~3 megs)
krusader			# file manager, more power-user-oriented than Dolphin (~4 megs)

# kdeedu apps
blinken
kalzium
kanagram
kgeography
khangman
kiten
klettres
ktouch
kturtle
kwordquiz
parley
step
marble
kstars
kalgebra
kbruch
kig
kmplot
rocs
cantor

# Cantor backends
cantor-R		# Cantor R backend, built against R-core at compile time
maxima			# runtime dependency of the Cantor Maxima backend
octave			# runtime dependency of the Cantor Octave backend

# KDE 4 translations
kde-l10n-*
koffice-langpack-*

# use yum-presto by default
yum-presto

## avoid serious bugs by omitting broken stuff

%end

%post
%end
