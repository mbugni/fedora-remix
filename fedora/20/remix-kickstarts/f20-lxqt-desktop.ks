## f20-lxqt-desktop.ks

%include f20-base-desktop.ks

repo --name=lxqt-fedora --baseurl=http://download.opensuse.org/repositories/X11:/lxde:/lxqt:/fedora/Fedora_$releasever/

%packages

# Unwanted stuff
-*akonadi*
-gnome*
-kdepim*
-system-config-printer

ark
bluedevil
compton
compton-conf
kate
kcalc
kde-style-oxygen
konsole
libfm-gtk
liblxqt-mount
libqtxdg-qt4
lximage-qt
lxqt-about
lxqt-common
lxqt-config
lxqt-config-randr
lxqt-globalkeys
lxqt-lightdm-greeter
lxqt-notificationd
lxqt-openssh-askpass
lxqt-panel
lxqt-policykit
lxqt-powermanagement
lxqt-qtplugin
lxqt-runner
lxqt-session
network-manager-applet
obconf-qt
okular
openbox
oxygen-gtk
oxygen-icon-theme
pavucontrol
pcmanfm-qt
phonon-backend-gstreamer

# Internet
firefox
thunderbird

# Tools
gparted

%end


%post

echo ""
echo "*****************"
echo "POST LXQT DESKTOP"
echo "*****************"

# add initscript
cat >> /etc/rc.d/init.d/livesys << EOF

# set up lightdm autologin
sed -i 's/^#autologin-user=.*/autologin-user=liveuser/' /etc/lightdm/lightdm.conf
sed -i 's/^#autologin-user-timeout=.*/autologin-user-timeout=0/' /etc/lightdm/lightdm.conf

# set LXQT as default session, otherwise login will fail
sed -i 's/^#user-session=.*/user-session=lxqt/' /etc/lightdm/lightdm.conf

# show liveinst.desktop on desktop and in menu
sed -i 's/NoDisplay=true/NoDisplay=false/' /usr/share/applications/liveinst.desktop

# chmod +x ~/Desktop/liveinst.desktop to disable security warning
chmod +x /usr/share/applications/liveinst.desktop

# make sure to set the right permissions and selinux contexts
chown -R liveuser:liveuser /home/liveuser/
restorecon -R /home/liveuser/

EOF

%end


%post

# Disable the update notifications of apper
cat > /etc/kde/apper << APPER_EOF
[CheckUpdate]
autoUpdate=0
distroUpgrade=0
interval=0
APPER_EOF

cat > /etc/kde/kdeglobals << GLOBALS_EOF
[General]
BrowserApplication[\$e]=firefox.desktop

[KDE]
SingleClick=false

[Locale]
Country=it
Language=it:en_US
GLOBALS_EOF

# Sets oxygen-gtk2 as default gtk2 theme
mkdir -p /etc/gtk-2.0
cat > /etc/gtk-2.0/gtkrc << EOF_GTKRC
include "/usr/share/themes/oxygen-gtk/gtk-2.0/gtkrc"
gtk-icon-theme-name = "oxygen"
gtk-fallback-icon-theme = "gnome"
EOF_GTKRC

# Sets oxygen-gtk3 as default gtk3 theme
mkdir -p /etc/skel/.config/gtk-3.0
cat > /etc/skel/.config/gtk-3.0/settings.ini << EOF_SETTINGS_GTK3
[Settings]
gtk-theme-name = oxygen-gtk
gtk-icon-theme-name = oxygen
gtk-fallback-icon-theme = gnome
EOF_SETTINGS_GTK3

# Sets oxygen as default qt theme
mkdir -p /etc/skel/.config
cp /etc/Trolltech.conf  /etc/skel/.config/
echo 'style=oxygen' >> /etc/skel/.config/Trolltech.conf

# External LXQT repository
cat > /etc/yum.repos.d/lxqt-fedora.repo << LXQT_REPO_EOF
[lxqt-fedora]
name=LXQT ported to Fedora \$releasever
type=rpm-md
baseurl=http://download.opensuse.org/repositories/X11:/lxde:/lxqt:/fedora/Fedora_\$releasever/
gpgcheck=1
gpgkey=http://download.opensuse.org/repositories/X11:/lxde:/lxqt:/fedora/Fedora_\$releasever/repodata/repomd.xml.key
enabled=1
LXQT_REPO_EOF

%end