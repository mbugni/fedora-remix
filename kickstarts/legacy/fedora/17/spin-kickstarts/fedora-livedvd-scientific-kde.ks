#fedora-livedvd-scientific-kde.ks
# With KDE Desktop

# Fedora Scientific: For researchers in Science and Engineering
# Fedora-Scientific aims to create a Fedora which has the generic
# toolset for the researcher
# Web: https://fedoraproject.org/wiki/Scientific_Spin
# Web: http://spins.fedoraproject.org/scientific-kde/

# Maintainer: Amit Saha <amitksaha@fedoraproject.org>
#             https://fedoraproject.org/wiki/User:Amitksaha

# Last modified: March 10, 2012.

%include fedora-live-kde.ks

# DVD payload
part / --size 10000

%packages

# Installing the default/mandatory packages from engineering & scientific
@engineering-and-scientific

# scilab
scilab
scilab-devel
scilab-doc

#Devel tools

#Install the mandatory packages from dev-tools and dev-libs
# C/C++ compiler, gdb, autotools, bison, flex, make, strace..
@development-tools
@development-libs

# Misc. related utils
ddd
valgrind
ipython

# Include Java development tools
@java-development

#fortran compiler
gcc-gfortran

# GUI for R
rkward

# GUI for Octave
qtoctave

# IDEs for the IDE folks
#netbeans
eclipse
spyder

#writing & publishing
emacs
emacs-color-theme
vim
scribus
scite
lyx
kile

#Presentation, Bibliography & Document arrangement 
#tools
BibTool
pdfshuffler


# Parallel/Distributed computing libraries/tools
openmpi
valgrind-openmpi
pvm
pvm-gui #will install 'pvm' as well
libgomp
python-pp


#Version control- a GUI for each as well

# Installing rapidsvn will also install subversion package
rapidsvn 
# Install git-gui, will also install git
git-gui
# Mercurial
mercurial
mercurial-hgk

#Backup Utilities
backintime-kde


#needs to install this specifically because of some conflict between openmpi
#and emacs (http://lists.fedoraproject.org/pipermail/devel/2011-July/153812.html)
libotf

#root
root
root-gui-fitpanel
root-python

#Multiple jobs/clustering system
torque
torque-server
torque-scheduler
torque-gui
torque-libs
torque-mom
python-pbs

#Drawing, Picture viewing tools, Visualization tools
dia
inkscape
xzgv
gimp
ggobi
ggobi-devel
g3data
Mayavi

#Misc. Utils
screen
rlwrap
xchat
shutter
fig2ps
bibtex2html
hevea

#Include Mozilla Firefox
firefox

%end

%post

%end
