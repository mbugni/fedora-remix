# fedora-design-suite.ks
# Based on Live Desktop
# Description:
# - A Spin targeted towards professional designers
# Website: http://fedoraproject.org/wiki/Design_Suite
# Maintainers:
# - Luya Tshimbalanga <luya AT fedoraproject DOT org>
# - Previous maintainer Sebastian Dziallas

%include fedora-live-desktop.ks

#DVD size partition
part / --size 8192

%packages

# graphics
blender
bluefish 
#cinepaint
cmyktool
darktable
dia
entangle
fontforge
font-manager 
gimp
gimp-*-plugin
gimp-data-extras
gimp-gap
gimp-paint-studio
gimp-high-pass-filter
gimp-normalmap
gimp-resynthesizer
gimp-separate+
gpick
GREYCstoration-gimp 
hugin 
mypaint
inkscape
nautilus-image-converter
optipng
phatch
screenruler
simple-scan
scribus
colord-extra-profiles 
synfigstudio
xournal

# office
vym
pdfshuffler  

# internet
filezilla

# audio & video
audacity
pitivi

# fonts
aajohan-comfortaa-fonts
adobe-source-sans-pro-fonts
campivisivi-titillium-fonts
lato-fonts
overpass-fonts

# removal of duplicated and unneeded applications
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
favorite-apps=['firefox.desktop', 'evolution.desktop', 'shotwell.desktop', 'gimp.desktop', 'inkscape.desktop', 'blender.desktop', 'libreoffice-writer.desktop', 'scribus.desktop', 'nautilus.desktop', 'bijiben.desktop', 'anaconda.desktop', 'list-design-tutorials.desktop']
#Enable categories in Gnome Shell
app-folder-categories=['Utilities', 'Games', 'Sundry', 'Office', 'Network', 'Internet', 'Graphics', 'Multimedia', 'System', 'Development', 'Accessories', 'System Settings', 'wine-wine', 'Crossover', 'Crossover Games', 'Science', 'Education', 'Universal Access', 'Other']
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

# rebuild schema cache with any overrides we installed
glib-compile-schemas /usr/share/glib-2.0/schemas

#EOF

%end

