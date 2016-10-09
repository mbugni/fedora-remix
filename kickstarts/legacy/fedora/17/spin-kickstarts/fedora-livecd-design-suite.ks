# fedora-design-suite.ks
#
# Description:
# - A Spin targeted towards professional designers
#
# Maintainer:
# - Sebastian Dziallas <sdz AT fedoraproject DOT org>

%include fedora-live-mini.ks

%packages

# gnome desktop
gdm
gnome-panel
gnome-session
gnome-shell
metacity
nautilus

# graphics
blender
cinepaint
# entangle # does not work in a gtk+ 3 environment
fontforge
fontmatrix
# fyre
gimp
gimp-*-plugin
GREYCstoration-gimp 
# hugin # is huge
inkscape
mypaint
nautilus-image-converter
optipng
# pinta # is huge because it needs mono
postr
rawtherapee
scribus
shotwell
synfigstudio
ufraw
xournal

# office
abiword
dia
evince
gnote
gnumeric
# hamster-applet # no more applets in gnome-shell
# pdfmod

# internet
empathy
evolution
firefox

# audio & video
# jokosher # no longer available
pitivi
rhythmbox
totem

# system
gedit
gnome-terminal
gtk-recordmydesktop
NetworkManager-gnome

%end

%post
cat >> /etc/rc.d/init.d/livesys << EOF
# disable screensaver locking
cat >> /usr/share/glib-2.0/schemas/org.gnome.desktop.screensaver.gschema.override << FOE
[org.gnome.desktop.screensaver]
lock-enabled=false
FOE

# and hide the lock screen option
cat >> /usr/share/glib-2.0/schemas/org.gnome.desktop.lockdown.gschema.override << FOE
[org.gnome.desktop.lockdown]
disable-lock-screen=true
FOE

# disable updates plugin
cat >> /usr/share/glib-2.0/schemas/org.gnome.settings-daemon.plugins.updates.gschema.override << FOE
[org.gnome.settings-daemon.plugins.updates]
active=false
FOE

# make the installer show up
if [ -f /usr/share/applications/liveinst.desktop ]; then
  # Show harddisk install in shell dash
  sed -i -e 's/NoDisplay=true/NoDisplay=false/' /usr/share/applications/liveinst.desktop ""
  # need to move it to anaconda.desktop to make shell happy
  mv /usr/share/applications/liveinst.desktop /usr/share/applications/anaconda.desktop

  cat >> /usr/share/glib-2.0/schemas/org.gnome.shell.gschema.override << FOE
[org.gnome.shell]
favorite-apps=['firefox.desktop', 'evolution.desktop', 'empathy.desktop', 'rhythmbox.desktop', 'shotwell.desktop', 'openoffice.org-writer.desktop', 'nautilus.desktop', 'inkscape-course.desktop', 'anaconda.desktop']
FOE

  # add installer to user menu
  mkdir -p ~liveuser/.local/share/gnome-shell/extensions/Installer@shell-extensions.fedoraproject.org
  cat >> ~liveuser/.local/share/gnome-shell/extensions/Installer@shell-extensions.fedoraproject.org/metadata.json << FOE
{"shell-version": ["2.91.91"], "uuid": "Installer@shell-extensions.fedoraproject.org", "name": "Installer", "description": "Install OS from user menu"}
FOE

  cat >> ~liveuser/.local/share/gnome-shell/extensions/Installer@shell-extensions.fedoraproject.org/extension.js << FOE
const PopupMenu = imports.ui.popupMenu;
const Shell = imports.gi.Shell;
const Main = imports.ui.main;
const Util = imports.misc.util;

function main() {
    let app = Shell.AppSystem.get_default().get_app('anaconda.desktop');
    let item = new PopupMenu.PopupMenuItem(app.get_name());
    item.connect('activate', function() { app.activate(-1); });

    Main.panel._statusmenu.menu.addMenuItem(item, Main.panel._statusmenu.menu._getMenuItems().length - 1);
}
FOE

fi

# rebuild schema cache with any overrides we installed
glib-compile-schemas /usr/share/glib-2.0/schemas

# set up auto-login
cat >> /etc/gdm/custom.conf << FOE
[daemon]
AutomaticLoginEnable=True
AutomaticLogin=liveuser
FOE

# Turn off PackageKit-command-not-found while uninstalled
if [ -f /etc/PackageKit/CommandNotFound.conf ]; then
  sed -i -e 's/^SoftwareSourceSearch=true/SoftwareSourceSearch=false/' /etc/PackageKit/CommandNotFound.conf
fi

# Add link to the Inkscape Course
cat >> /usr/share/applications/inkscape-course.desktop << FOE
[Desktop Entry]
Name=Introduction To Inkscape
GenericName=Inkscape Course
Comment=Materials from Máirín Duffy's Inkscape Class
Exec=xdg-open http://linuxgrrl.com/learn/Introduction_To_Inkscape
Type=Application
Icon=fedora-logo-icon
Categories=Graphics;Documentation;
FOE
chmod a+x /usr/share/applications/inkscape-course.desktop

EOF

%end
