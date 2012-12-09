# Custom CentOS Live GNOME Kickstart

%include c6-desktop-common.ks

%packages

# Unwanted stuff
-abrt*
-at-*
-compiz*
-gnome-games*
-gnote*
-orca*

@basic-desktop --nodefaults
evince
file-roller
gedit
gnome-media
gnome-packagekit

### Internet
firefox
thunderbird

# Tools
gparted

%end

%post
cat >> /etc/rc.d/init.d/livesys << EOF

# Show harddisk install on the desktop
sed -i -e 's/NoDisplay=true/NoDisplay=false/' /usr/share/applications/liveinst.desktop
mkdir /home/liveuser/Desktop
cp /usr/share/applications/liveinst.desktop /home/liveuser/Desktop
chown -R liveuser.liveuser /home/liveuser/Desktop
chmod a+x /home/liveuser/Desktop/liveinst.desktop

# But not trash and home
# gconftool-2 --direct --config-source=xml:readwrite:/etc/gconf/gconf.xml.defaults -s -t bool /apps/nautilus/desktop/trash_icon_visible false >/dev/null
# gconftool-2 --direct --config-source=xml:readwrite:/etc/gconf/gconf.xml.defaults -s -t bool /apps/nautilus/desktop/home_icon_visible false >/dev/null

# Turn off PackageKit-command-not-found while uninstalled
# sed -i -e 's/^SoftwareSourceSearch=true/SoftwareSourceSearch=false/' /etc/PackageKit/CommandNotFound.conf

EOF

%end

## REMIX gnome ################################################################

%post

echo -e "\n**********\nPOST GNOME\n**********\n"

# Switching to Thunderbird as the default MUA
gconftool-2 --direct --config-source=xml:readwrite:/etc/gconf/gconf.xml.defaults --type string --set /desktop/gnome/url-handlers/mailto/command "thunderbird %" >/dev/null

# Disable auto-update
gconftool-2 --direct --config-source=xml:readwrite:/etc/gconf/gconf.xml.defaults --type string --set /apps/gnome-packagekit/update-icon/auto_update "none" >/dev/null

# Disable PackageKit update checking by default
gconftool-2 --direct --config-source=xml:readwrite:/etc/gconf/gconf.xml.defaults --type int --set /apps/gnome-packagekit/update-icon/frequency_get_updates "0" >/dev/null

# Desktop font settings
gconftool-2 --direct --config-source=xml:readwrite:/etc/gconf/gconf.xml.defaults --type string --set /apps/nautilus/preferences/desktop_font "Sans Bold Italic 10" >/dev/null

%end
