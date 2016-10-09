#fedora-livedvd-scientific-kde.ks
# With KDE Desktop

# Fedora Scientific: For researchers in Science and Engineering
# Fedora-Scientific aims to create a Fedora which has the generic
# toolset for the researcher
# Web: https://fedoraproject.org/wiki/Scientific_Spin
# Web: http://spins.fedoraproject.org/scientific-kde/

# Maintainer: Amit Saha <amitksaha@fedoraproject.org>
#             https://fedoraproject.org/wiki/User:Amitksaha

%include fedora-live-kde.ks

# The recommended part size for DVDs is too close to use for the scientific spin
part / --size 12288

%packages

# Installing the default/mandatory packages from engineering & scientific
@engineering-and-scientific

# scilab
#scilab
#scilab-devel
#scilab-doc

# sagemath
# BZ #1006230 should fix this
#sagemath
#sagemath-notebook

#Devel tools

#Install the mandatory packages from dev-tools and dev-libs
# C/C++ compiler, gdb, autotools, bison, flex, make, strace..
@development-tools
@development-libs
@c-development
@rpm-development-tools
#others, not included
# C++ libraries
blitz-devel
armadillo-devel

# Misc. related utils
ddd
valgrind

#python 2 tools/libraries not included from the groups
python-tools
python-ipython
python-ipython-console
python-ipython-notebook
sympy
python-networkx
python-pandas

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

# matplotlib backends
python-matplotlib-qt4
python-matplotlib-tk
python3-matplotlib-qt4
python3-matplotlib-tk

# Include Java development tools
@java-development
apache-commons-math

#fortran compiler
gcc-gfortran

# GUI for R
rkward

# GUI for Octave
qtoctave

# IDEs for the IDE folks
@eclipse
spyder

#writing & publishing
emacs
emacs-color-theme
vim
scribus
#scite
lyx
kile

#Presentation, Bibliography & Document arrangement 
#tools
BibTool
pdfshuffler

# Parallel/Distributed computing libraries/tools
openmpi
openmpi-devel
valgrind-openmpi
libgomp
python-pp
mpi4py-openmpi
python3-mpi4py-openmpi

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

#needs to install this specifically because of some conflict between openmpi
#and emacs (http://lists.fedoraproject.org/pipermail/devel/2011-July/153812.html)
libotf

#root
root
root-gui-fitpanel
root-python

#Multiple jobs/clustering system
# torque
# torque-server
# torque-scheduler
# torque-gui
# torque-libs
# torque-mom
# python-pbs

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
tmux
rlwrap
hexchat
shutter
fig2ps
bibtex2html
hevea

#Include Mozilla Firefox
firefox

%end

%post

%end