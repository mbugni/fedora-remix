## f20-razorqt-desktop.ks

%include f20-base-desktop.ks

%packages

# Unwanted stuff
-*akonadi*
-gnome*
-kdepim*
-system-config-printer

ark
bluedevil
dolphin
gnome-icon-theme-legacy
gwenview
kate
kcalc
kcharselect
kcm_colors
# kcm_touchpad
kde-style-oxygen
# kde-workspace
konsole
# kscreen
ksnapshot
lightdm-razorqt
network-manager-applet
obconf
okular
openbox
oxygen-gtk
oxygen-icon-theme
pavucontrol
phonon-backend-gstreamer
razorqt
razorqt-themes
xbacklight
xsettings-kde
NetworkManager-l2tp
NetworkManager-openvpn
NetworkManager-pptp

# Internet
firefox
thunderbird

# Tools
gparted

%end


%post

echo ""
echo "******************"
echo "POST RAZOR DESKTOP"
echo "******************"

# make oxygen-gtk the default GTK theme for root (see #683855, #689070, #808062)
mkdir -p /etc/gtk-2.0
cat > /etc/gtk-2.0/gtkrc << EOF_GTK2
include "/usr/share/themes/oxygen-gtk/gtk-2.0/gtkrc"
gtk-icon-theme-name = "oxygen"
gtk-fallback-icon-theme = "gnome"
EOF_GTK2
mkdir -p /etc/gtk-3.0
cat > /etc/gtk-3.0/settings.ini << EOF_GTK3
[Settings]
gtk-theme-name = oxygen-gtk
gtk-icon-theme-name = oxygen
gtk-fallback-icon-theme = gnome
EOF_GTK3

# add initscript
cat >> /etc/rc.d/init.d/livesys << EOF

# set up lightdm autologin
sed -i 's/^#autologin-user=.*/autologin-user=liveuser/' /etc/lightdm/lightdm.conf
sed -i 's/^#autologin-user-timeout=.*/autologin-user-timeout=0/' /etc/lightdm/lightdm.conf

# set RazorQT as default session, otherwise login will fail
sed -i 's/^#user-session=.*/user-session=razor/' /etc/lightdm/lightdm.conf

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

# Sets oxygen as default qt theme
mkdir -p /etc/skel/.config
cp /etc/Trolltech.conf  /etc/skel/.config/
echo 'style=oxygen' >> /etc/skel/.config/Trolltech.conf

# Autostart bluedevil applet in systray (disabled)
# cp /usr/share/applications/kde4/bluedevil-monolithic.desktop /etc/xdg/autostart/razor-bluedevil.desktop
# cat >> /etc/xdg/autostart/razor-bluedevil.desktop << EOF_BLUEDEVIL
# OnlyShowIn=Razor;
# X-Razor-Need-Tray=true
# Hidden=true
# EOF_BLUEDEVIL

# Autostart KDE settings (disabled)
# cat > /etc/xdg/autostart/razor-kde-settings.desktop << EOF_KCMINIT
# [Desktop Entry]
# Type=Application
# Name=KDE Settings
# Name[it]=Impostazioni di KDE
# OnlyShowIn=Razor;
# TryExec=/bin/kcminit
# Hidden=true
# NoDisplay=true
# EOF_KCMINIT

%end
