#fedora-live-astronomy-kde.ks
# With KDE Desktop

# Fedora Astronomy: For astronomers and astrophysicists
# Fedora-Astronomy aims to create a Fedora which has the generic
# toolset for the astronomer
#
# Web: https://fedoraproject.org/wiki/SIGs/Astronomy/AstroSpin
#
# Partly based on Scientific KDE Spin 
#     https://fedoraproject.org/wiki/Scientific_Spin
#

# Maintainer: Christian Dersch <lupinix@fedoraproject.org>
#             https://fedoraproject.org/wiki/User:Lupinix

%include fedora-live-kde.ks

# The recommended part size for DVDs is too close to use for the astronomy spin
part / --size 12288

%packages

# Installing the default/mandatory packages from engineering & scientific
@engineering-and-scientific

# astronomical data analysis
cdsclient
fpack
gcx
psfex
saoimage
scamp
sextractor
siril
skyviewer
swarp

# Observatory: KStars + INDI drivers + Skychart
indi-aagcloudwatcher
indi-apogee
indi-eqmod
indi-gphoto
indi-sx
kstars
skychart
skychart-data-dso
skychart-data-stars
stellarium

# misc. astronomy
celestia
xvarstar

# Some astro environment stuff
astronomy-bookmarks
astronomy-menus
astronomy-menus-toplevel

#Devel tools

#Install the mandatory packages from dev-tools and dev-libs
# C/C++ compiler, gdb, autotools, bison, flex, make, strace..
@development-tools
@development-libs
@c-development
@rpm-development-tools
# for astronomy
cfitsio-devel
CCfits-devel
libnova-devel
wcslib-devel


#python 2 tools/libraries not included from the groups
python-tools
python-ipython
python-ipython-console
python-ipython-notebook
sympy
python-networkx
python-pandas
# Python astronomy
astropy-tools
python-astropy
python-astroML
python-photutils
python-sep
pyephem
APLpy
ATpy


#python 3 and tools/libraries not included from the groups
python3
python3-tools
python3-matplotlib
python3-scipy
python3-numpy
python3-ipython
python3-ipython-console
python3-ipython-notebook
python3-sympy
python3-networkx
python3-pandas
# Python 3 astronomy
python3-astropy
python3-astroML
python3-APLpy
python3-ATpy
python3-photutils
python3-sep

# matplotlib backends
python-matplotlib-qt4
python-matplotlib-qt5
python-matplotlib-tk
python3-matplotlib-qt4
python3-matplotlib-qt5
python3-matplotlib-tk


# Python IDE very useful for scientific use
spyder


#Version control- a GUI for each as well

# Installing rapidsvn will also install subversion package
rapidsvn 
git
git-gui
# Mercurial
mercurial
mercurial-hgk

#Backup Utilities
backintime-kde

#Drawing, Picture viewing tools, Visualization tools
dia
gimp
inkscape
kst
kst-docs
kst-fits
scidavis

#Misc. Utils
ImageMagick
kate
kate-plugins
rlwrap
screen

# Omit KDE 4 translations for now: https://bugzilla.redhat.com/show_bug.cgi?id=1197940
-kde-l10n-*
-calligra-l10n-*

%end

%post

%end
