# fedora-livecd-xfce.ks
#
# Description:
# - Fedora Live Spin with the light-weight XFCE Desktop Environment
#
# Maintainer(s):
# - Rahul Sundaram    <sundaram@fedoraproject.org>
# - Christoph Wickert <cwickert@fedoraproject.org>
# - Kevin Fenzi       <kevin@tummy.com>
# - Adam Miller       <maxamillion@fedoraproject.org>

%include fedora-live-base.ks
%include fedora-live-minimization.ks

%packages

# Office
abiword
gnumeric

# Graphics
epdfview

# Development
geany

# Internet
firefox
# Add the midori browser as a lighter alternative
midori
claws-mail
claws-mail-plugins-archive
claws-mail-plugins-att-remover
claws-mail-plugins-attachwarner
claws-mail-plugins-bogofilter
claws-mail-plugins-cachesaver
claws-mail-plugins-fetchinfo
claws-mail-plugins-mailmbox
claws-mail-plugins-newmail
claws-mail-plugins-notification
claws-mail-plugins-pgp
claws-mail-plugins-rssyl
claws-mail-plugins-smime
claws-mail-plugins-spam-report
claws-mail-plugins-tnef
claws-mail-plugins-vcalendar
liferea
pidgin
remmina
remmina-plugins-rdp
remmina-plugins-vnc
transmission

# Sound & Video
alsa-plugins-pulseaudio
asunder
cheese
quodlibet
pavucontrol
parole
xfburn

# System
gparted
-gnome-disk-utility
gigolo
setroubleshoot

# Accessories
catfish
galculator
seahorse

# More Desktop stuff
# java plugin
icedtea-web
NetworkManager-vpnc
NetworkManager-openvpn
NetworkManager-gnome
NetworkManager-pptp
desktop-backgrounds-compat
gnome-bluetooth
xscreensaver
xdg-user-dirs-gtk

# FIXME: work around #746693
metacity

# default artwork
fedora-icon-theme
adwaita-cursor-theme
adwaita-gtk2-theme
adwaita-gtk3-theme

# command line
irssi
mutt
ntfs-3g
powertop
rtorrent
vim-enhanced
wget
yum-utils

# Xfce packages
@xfce-desktop
Terminal
gtk-xfce-engine
orage
ristretto
thunar-volman
thunar-media-tags-plugin
xarchiver
xfce4-battery-plugin
xfce4-cellmodem-plugin
xfce4-clipman-plugin
xfce4-cpugraph-plugin
xfce4-datetime-plugin
xfce4-dict-plugin
xfce4-diskperf-plugin
xfce4-eyes-plugin
xfce4-fsguard-plugin
xfce4-genmon-plugin
xfce4-mailwatch-plugin
xfce4-mount-plugin
xfce4-netload-plugin
xfce4-notes-plugin
xfce4-places-plugin
xfce4-power-manager
xfce4-quicklauncher-plugin
xfce4-screenshooter-plugin
xfce4-sensors-plugin
xfce4-smartbookmark-plugin
xfce4-systemload-plugin
xfce4-taskmanager
xfce4-time-out-plugin
xfce4-timer-plugin
xfce4-verve-plugin
# we already have nm-applet
#xfce4-wavelan-plugin
xfce4-weather-plugin
xfce4-websearch-plugin
xfce4-xfswitch-plugin
xfce4-xkb-plugin
# system-config-printer does printer management better
#xfprint
xfwm4-themes

# dictionaries are big
-aspell-*
#-man-pages-*

# more fun with space saving
-gimp-help
# not needed, but as long as there is space left, we leave this in
#-desktop-backgrounds-basic

# save some space
-autofs
-acpid

# drop some system-config things
-system-config-boot
-system-config-lvm
-system-config-network
-system-config-rootpassword
#-system-config-services
-policycoreutils-gui

%end

%post
# xfce configuration

# create /etc/sysconfig/desktop (needed for installation)

cat > /etc/sysconfig/desktop <<EOF
PREFERRED=/usr/bin/startxfce4
EOF

cat >> /etc/rc.d/init.d/livesys << EOF

mkdir -p /home/liveuser/.config/xfce4

cat > /home/liveuser/.config/xfce4/helpers.rc << FOE
MailReader=sylpheed-claws
FileManager=Thunar
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

# set up auto-login
cat >> /etc/gdm/custom.conf << FOE
[daemon]
AutomaticLoginEnable=True
AutomaticLogin=liveuser
FOE

# Show harddisk install on the desktop
sed -i -e 's/NoDisplay=true/NoDisplay=false/' /usr/share/applications/liveinst.desktop
mkdir /home/liveuser/Desktop
cp /usr/share/applications/liveinst.desktop /home/liveuser/Desktop

# this goes at the end after all other changes. 
chown -R liveuser:liveuser /home/liveuser
restorecon -R /home/liveuser

EOF

%end

