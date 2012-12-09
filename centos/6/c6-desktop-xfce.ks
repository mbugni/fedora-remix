## c6-desktop-xfce.ks

%include c6-desktop-common.ks

%packages

# Unwanted stuff
-abrt*
-at-*
-caribou*
-leafpad*
-*nodoka*
-orca*
-xarchiver
-xfce4-power*

@xfce-desktop
file-roller
gedit
gnome-power-manager

# Internet
firefox
thunderbird

# Office
evince

# Sound & Video
alsa-plugins-pulseaudio
pavucontrol

# Tools
gparted
-gnome-disk-utility
gigolo
# setroubleshoot

# Accessories
# catfish
# galculator
# seahorse
ConsoleKit-x11

# More Desktop stuff
xscreensaver-base
xdg-user-dirs-gtk

# default artwork
gtk-xfce-engine

# command line
ntfs-3g
vim-enhanced
wget
yum-utils

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
#-system-config-boot
-system-config-lvm
-system-config-network
#-system-config-rootpassword
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
# sed -i 's/^#autologin-user=/autologin-user=liveuser/' /etc/lightdm/lightdm.conf 
# sed -i 's/^#autologin-user-timeout=0/autologin-user-timeout=30/' /etc/lightdm/lightdm.conf

# Show harddisk install on the desktop
sed -i -e 's/NoDisplay=true/NoDisplay=false/' /usr/share/applications/liveinst.desktop
mkdir /home/liveuser/Desktop
cp /usr/share/applications/liveinst.desktop /home/liveuser/Desktop
chown -R liveuser.liveuser /home/liveuser/Desktop
chmod a+x /home/liveuser/Desktop/liveinst.desktop

# this goes at the end after all other changes. 
chown -R liveuser:liveuser /home/liveuser
restorecon -R /home/liveuser

EOF

%end

## REMIX xfce

%post

echo -e "\n**********\nPOST XFCE\n**********\n"

# Disable auto-update
gconftool-2 --direct --config-source=xml:readwrite:/etc/gconf/gconf.xml.defaults --type string --set /apps/gnome-packagekit/update-icon/auto_update "none" >/dev/null

# Disable PackageKit update checking by default
gconftool-2 --direct --config-source=xml:readwrite:/etc/gconf/gconf.xml.defaults --type int --set /apps/gnome-packagekit/update-icon/frequency_get_updates "0" >/dev/null

mkdir -p /etc/skel/.config/xfce4

cat > /etc/skel/.config/xfce4/helpers.rc << FOE
MailReader=thunderbird
FileManager=Thunar
FOE

mkdir -p /etc/skel/.config/xfce4/xfconf/xfce-perchannel-xml

sed -e 's/property name="ThemeName"\(.*\)value="\(.*\)"/property name="ThemeName"\1value="Clearlooks"/g' /etc/xdg/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml | \
sed -e 's/property name="IconThemeName"\(.*\)value="\(.*\)"/property name="IconThemeName"\1value="System"/g' > /etc/skel/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml

cat > /etc/skel/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml << FOE
<?xml version="1.0" encoding="UTF-8"?>

<channel name="xfce4-desktop" version="1.0">
  <property name="backdrop" type="empty">
    <property name="screen0" type="empty">
      <property name="monitor0" type="empty">
        <property name="image-path" type="string" value="/usr/share/backgrounds/default.png"/>
      </property>
    </property>
  </property>
</channel>
FOE

%end
