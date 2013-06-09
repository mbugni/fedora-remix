# Maintained by the Fedora Robotics SIG:
# http://fedoraproject.org/wiki/SIGs/Robotics
# mailto:robotics@lists.fedoraproject.org

%include fedora-live-base.ks
%include fedora-live-minimization.ks

# The recommended part size for DVDs is too close to use for the robotics spin
part / --size 10240

%packages
# Start with GNOME
@gnome-desktop

# Add robotics development packages
@robotics-suite
pcl-devel
player-devel
stage-devel
mrpt-devel

# Add version control packages
git
mercurial

# Remove extra gnome-y things
-@graphical-internet
-@games
-@sound-and-video

# Add a web browser
firefox

# Remove office suite
-libreoffice-*
-planner

# Drop the Java plugin
-icedtea-web

# Drop things that pull in perl
-linux-atm

# No printing
-foomatic-db-ppds
-foomatic

# Dictionaries are big
-aspell-*
-hunspell-*
-man-pages*
-words

# Help and art can be big, too
-gnome-user-docs
-evolution-help
-desktop-backgrounds-basic
-*backgrounds-extras

# Legacy cmdline things we don't want
-krb5-auth-dialog
-krb5-workstation
-pam_krb5
-quota
-nano
-dos2unix
-finger
-ftp
-jwhois
-mtr
-pinfo
-rsh
-nfs-utils
-ypbind
-yp-tools
-rpcbind
-acpid
-ntsysv

# Drop some system-config things
-system-config-boot
-system-config-language
-system-config-network
-system-config-rootpassword
-system-config-services
-policycoreutils-gui

%end

# Rip the post-configuration from the live-desktop, set default shortcuts to IDEs 
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
favorite-apps=['firefox.desktop', 'eclipse.desktop', 'arduino.desktop', 'gnome-terminal.desktop','nautilus.desktop', 'anaconda.desktop']
FOE

fi

# rebuild schema cache with any overrides we installed
glib-compile-schemas /usr/share/glib-2.0/schemas

# set up auto-login
cat > /etc/gdm/custom.conf << FOE
[daemon]
AutomaticLoginEnable=True
AutomaticLogin=liveuser
FOE

# Turn off PackageKit-command-not-found while uninstalled
if [ -f /etc/PackageKit/CommandNotFound.conf ]; then
  sed -i -e 's/^SoftwareSourceSearch=true/SoftwareSourceSearch=false/' /etc/PackageKit/CommandNotFound.conf
fi

EOF
%end
