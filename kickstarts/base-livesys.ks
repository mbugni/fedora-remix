# base-livesys.ks
#
# Defines the basics for a live system.

%include base.ks

%post

echo ""
echo "POST BASE LIVESYS ************************************"
echo ""

# Create local remix scripts folder
mkdir -p /usr/local/libexec/remix

# Create post-install cleanup script
cat > /usr/local/libexec/remix/livesys-cleanup << CLEANUP_EOF
# livesys cleanup commands

echo "Cleaning up livesys resources..."
sudo sh -c 'systemctl disable livesys.service; systemctl disable livesys-late.service;
dnf --assumeyes remove anaconda\* livesys-scripts;
rm /etc/sysconfig/livesys* -rf; rm /var/lib/livesys -rf'
CLEANUP_EOF

# Add extra livesys script
mkdir -p /var/lib/livesys
cat >> /var/lib/livesys/livesys-session-extra << EOF_LIVESYS
#
# Use KDE X11 for auto-login session
sed -i "s/^Session=.*/Session=plasmax11.desktop/" /etc/sddm.conf
EOF_LIVESYS

##############################################
## Optional session extra script for Calamares
##############################################
# #
# # Remove default installer
# rm /home/liveuser/Desktop/*.desktop
# #
# # Copy installer icon on desktop
# mkdir /home/liveuser/Desktop
# cp -a /usr/share/applications/calamares.desktop /home/liveuser/Desktop/
# #
# # Set executable bit disable KDE security warning
# chmod +x /home/liveuser/Desktop/calamares.desktop
# #
# # Use su for privilege escalation due Calamares (se #2277485)
# mkdir -p /home/liveuser/.config/
# cat > /home/liveuser/.config/kdesurc << KDESU_EOF
# [super-user-command]
# super-user-command=su
# KDESU_EOF
# chown liveuser:liveuser /home/liveuser/.config/kdesurc

%end
