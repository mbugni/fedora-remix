# fedora-design-suite.ks
# Based on Live Workstation
# Description:
# - A Spin targeted towards professional designers
# Website: http://fedoraproject.org/wiki/Design_Suite
# Maintainers:
# - Luya Tshimbalanga <luya AT fedoraproject DOT org>
# - Previous maintainer Sebastian Dziallas

%include fedora-live-workstation.ks

#DVD size partition
part / --size 8192

%packages
# graphics
blender
LuxRender-blender
YafaRay-blender
bluefish 
colord-extra-profiles
darktable
dia
entangle
fontforge
font-manager 
gimp
gimp-elsamuko
gimp-*-plugin
gimp-data-extras
gimp-gap
gimp-paint-studio
gimp-high-pass-filter
gimp-normalmap
gimp-resynthesizer
gimp-separate+
gpick
GraphicsMagick
gmic-gimp
hugin 
ImageMagick
inkscape
inkscape-sozi
inkscape-table
mypaint
nautilus-image-converter
optipng
phatch
screenruler
simple-scan
scribus
shutter
synfigstudio
xournal

# office
vym
pdfmod
pdfshuffler  

# internet
filezilla
sparkleshare
sshpass

# audio & video
audacity
pitivi

# fonts
aajohan-comfortaa-fonts
adobe-source-sans-pro-fonts
campivisivi-titillium-fonts
lato-fonts
open-sans-fonts
overpass-fonts

# removal of unneeded applications
-gnome-boxes
-gthumb
-eog
-gnome-photos
-rdesktop

%end

%post
#Override the favorite desktop application in Dash
cat >> /usr/share/glib-2.0/schemas/org.gnome.shell.gschema.override << FOE
[org.gnome.shell]
favorite-apps=['firefox.desktop', 'shotwell.desktop', 'gimp.desktop', 'inkscape.desktop', 'blender.desktop', 'libreoffice-writer.desktop', 'scribus.desktop', 'nautilus.desktop', 'bijiben.desktop', 'anaconda.desktop', 'list-design-tutorials.desktop']
FOE

# Add link to lists of tutorials
cat >> /usr/share/applications/list-design-tutorials.desktop << FOE
[Desktop Entry]
Name=List of design tutorials
GenericName=List of Tutorials for Designers
Comment=Reference of Design Related Tutorials
Exec=xdg-open http://fedoraproject.org/wiki/Design_Suite/Tutorials
Type=Application
Icon=applications-graphics
Categories=Graphics;Documentation;
FOE
chmod a+x /usr/share/applications/list-design-tutorials.desktop

# Add information about Fedora Design Suite
cat >> /usr/share/applications/fedora-design-suite.desktop << FOE
[Desktop Entry]
Name=Design Suite Info
GenericName=About Design Suite
Comment=Wiki page of Design Suite
Name=About Design Suite
GenericName=About Design Suite 
Comment=Wiki page of Design Suite
Exec=xdg-open http://fedoraproject.org/wiki/Design_Suite
Type=Application
Icon=applications-internet
Categories=Documentation;
FOE
chmod a+x /usr/share/applications/fedora-design-suite.desktop

# Add information about Fedora Design Team
cat >> /usr/share/applications/fedora-design-team.desktop << FOE
[Desktop Entry]
Name=Design Team Info
GenericName=About Design Team 
Name=About Design Team
GenericName=About Design Team Wiki Page
Comment=Wiki page of Design Team
Exec=xdg-open http://fedoraproject.org/wiki/Design
Type=Application
Icon=applications-internet
Categories=Documentation;
FOE
chmod a+x /usr/share/applications/fedora-design-team.desktop

# rebuild schema cache with any overrides we installed
glib-compile-schemas /usr/share/glib-2.0/schemas

%end
