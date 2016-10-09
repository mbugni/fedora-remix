# Description : Live DVD image for Fedora/Free Electronic Lab
#
# Maintainer(s):
# - Chitlesh Goorah <chitlesh a fedoraproject.org>
# - Thibault North  <tnorth   a fedoraproject.org>

%include fedora-livecd-desktop.ks

# DVD payload
part / --size=8192

%packages

@electronic-lab

# Support for the Milkymist hardware community
@milkymist


# Office
dia
vym
libreoffice-writer
libreoffice-calc
libreoffice-impress
#libreoffice-extendedPDF
planner
graphviz


# debugging tools
make
gdb
valgrind
kdbg
wireshark-gnome
qemu


# EDA/CAD department
perl-Test-Pod
perl-Test-Pod-Coverage


# Removing unnecessary packages from the desktop spin
-abiword
-@games
-gimp
-gimp-libs
-gimp-data-extras
-kdebluetooth


%end

%post

%end
