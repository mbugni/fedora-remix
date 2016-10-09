## f19-xfce-desktop.ks

%include f19-base-desktop.ks

%packages

# Unwanted stuff
-abrt*
-at-*
-caribou*
-gdm*
-gnome-*
-*nodoka*
-orca*
-xarchiver

NetworkManager-*vpn*
Thunar
adwaita-gtk*-theme
blueman
catfish
desktop-backgrounds-compat
evince
fedora-icon-theme
file-roller
galculator
gedit
gnome-keyring-pam
gnome-packagekit
gtk-xfce-engine
gvfs
gvfs-fuse
gvfs-smb
lightdm
lightdm-gtk
network-manager-applet
nm-connection-editor
orage
# pavucontrol
ristretto
seahorse
thunar-archive-plugin
thunar-media-tags-plugin
thunar-volman
tumbler
# volumeicon
xdg-user-dirs-gtk
xfce4-about
xfce4-appfinder
xfce4-battery-plugin
xfce4-clipman-plugin
xfce4-datetime-plugin
xfce4-mixer
xfce4-panel
xfce4-places-plugin
xfce4-power-manager
xfce4-quicklauncher-plugin
xfce4-screenshooter-plugin
xfce4-session
xfce4-session-engines
xfce4-settings
xfce4-terminal
xfce4-whiskermenu-plugin
xfconf
xfdesktop
xfwm4
xfwm4-themes
xscreensaver-base
# yumex

# Internet
firefox
thunderbird  

# Tools
gparted

%end

%post
# xfce configuration

# This is a huge file and things work ok without it
rm -f /usr/share/icons/HighContrast/icon-theme.cache

# create /etc/sysconfig/desktop (needed for installation)

cat > /etc/sysconfig/desktop <<EOF
PREFERRED=/usr/bin/startxfce4
DISPLAYMANAGER=/usr/sbin/lightdm
EOF

cat >> /etc/rc.d/init.d/livesys << EOF

mkdir -p /home/liveuser/.config/xfce4

cat > /home/liveuser/.config/xfce4/helpers.rc << FOE
MailReader=thunderbird
FileManager=Thunar
WebBrowser=firefox
FOE

# disable screensaver locking (#674410)
cat >> /home/liveuser/.xscreensaver << FOE
mode:           off
lock:           False
dpmsEnabled:    False
FOE

# deactivate xfconf-migration (#683161)
rm -f /etc/xdg/autostart/xfconf-migration-4.6.desktop || :

# deactivate xfce4-panel first-run dialog (#693569)
mkdir -p /home/liveuser/.config/xfce4/xfconf/xfce-perchannel-xml
cp /etc/xdg/xfce4/panel/default.xml /home/liveuser/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml

# set up lightdm autologin
sed -i 's/^#autologin-user=.*/autologin-user=liveuser/' /etc/lightdm/lightdm.conf
sed -i 's/^#autologin-user-timeout=.*/autologin-user-timeout=0/' /etc/lightdm/lightdm.conf
#sed -i 's/^#show-language-selector=.*/show-language-selector=true/' /etc/lightdm/lightdm-gtk-greeter.conf

# set Xfce as default session, otherwise login will fail
sed -i 's/^#user-session=.*/user-session=xfce/' /etc/lightdm/lightdm.conf

# Show harddisk install on the desktop
sed -i -e 's/NoDisplay=true/NoDisplay=false/' /usr/share/applications/liveinst.desktop
mkdir /home/liveuser/Desktop
cp /usr/share/applications/liveinst.desktop /home/liveuser/Desktop

# and mark it as executable (new Xfce security feature)
chmod +x /home/liveuser/Desktop/liveinst.desktop

# this goes at the end after all other changes. 
chown -R liveuser:liveuser /home/liveuser
restorecon -R /home/liveuser

EOF

%end


## REMIX xfce

%post

echo ""
echo "*****************"
echo "POST XFCE DESKTOP"
echo "*****************"

# override default gnome settings
cat >> /usr/share/glib-2.0/schemas/org.gnome.remix.gschema.override << GNOME_EOF
[org.gnome.desktop.interface]
font-name='Sans 10'
document-font-name='Sans 10'
monospace-font-name='Monospace 10'

[org.gnome.settings-daemon.plugins.updates]
active=false
auto-download-updates=false
frequency-get-updates=0
frequency-get-upgrades=0
GNOME_EOF

glib-compile-schemas /usr/share/glib-2.0/schemas

mkdir -p /etc/skel/.config/xfce4

cat > /etc/skel/.config/xfce4/helpers.rc << HELPERS_EOF
MailReader=thunderbird
FileManager=Thunar
WebBrowser=firefox
HELPERS_EOF

%end