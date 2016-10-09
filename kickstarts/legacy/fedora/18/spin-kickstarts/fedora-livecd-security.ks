# Filename:
#   fedora-livecd-security.ks
# Description:
#   A fully functional live OS based on Fedora for use in security auditing, 
#   forensics research, and penetration testing.
# Maintainers:
#  Christoph Wickert <cwickert [AT] fedoraproject <dot> org>
#  Joerg Simon <jsimon [AT] fedoraproject <dot> org>
#  Fabian Affolter <fab [AT] fedoraproject <dot> org>
# Acknowledgements:
#   Fedora LiveCD Xfce Spin team - some work here was inherited, many thanks!
#   Fedora LXDE Spin - Copied over stuff to make LXDE Default
#   Luke Macken, Adam Miller for the original OpenBox Security ks and all 
#   the Security Applications! 
#   Hiemanshu Sharma <hiemanshu [AT] fedoraproject <dot> org>

%include fedora-live-base.ks
%include fedora-live-minimization.ks

%packages
### LXDE desktop
@lxde-desktop
lxlauncher
obconf
lxdm

### internet
#firefox
midori
icedtea-web
pidgin
sylpheed
transmission

### graphics
epdfview
#mtpaint

### audio & video
alsa-plugins-pulseaudio
asunder
lxmusic
gxine
gxine-mozplugin
pavucontrol
pnmixer
# I'm looking for something smaller than
#gnomebaker

### utils
galculator
parcellite
xpad

### system
gigolo

### more desktop stuff
fedora-icon-theme
adwaita-cursor-theme
adwaita-gtk2-theme
adwaita-gtk3-theme

# pam-fprint causes a segfault in LXDM when enabled
-fprintd-pam

# needed for automatic unlocking of keyring (#643435)
gnome-keyring-pam

network-manager-applet

# needed for xdg-open to support LXDE
perl-File-MimeInfo

xcompmgr
xdg-user-dirs-gtk
xscreensaver-extras

# use yumex instead of gnome-packagekit
yumex
-apper
-gnome-packagekit

# LXDE has lxpolkit. Make sure no other authentication agents end up in the spin.
-polkit-gnome
-polkit-kde

# make sure xfce4-notifyd is not pulled in
notification-daemon
-xfce4-notifyd

# make sure xfwm4 is not pulled in for firstboot
# https://bugzilla.redhat.com/show_bug.cgi?id=643416
metacity

# Command line
powertop
wget
yum-utils
yum-presto

# dictionaries are big
-aspell-*
-hunspell-*
-man-pages-*
-words

# save some space
-sendmail
ssmtp
-acpid

# drop some system-config things
-system-config-boot
#-system-config-language
-system-config-lvm
-system-config-rootpassword
#-system-config-services
-policycoreutils-gui
-gnome-disk-utility

# we need UPower for suspend and hibernate
upower

# gnome-terminal was replaced by Terminal
Terminal

# Security tools (just a plain package list because the comps groups will 
# only be available for Fedora > 18.
# python security-lab-maintenance.py -d
afftools
aide
aircrack-ng
airsnort
argus
bkhive
chkrootkit
dc3dd
ddrescue
dnsenum
dnsmap
dsniff
etherape
ettercap
ettercap-gtk
examiner
firewalk
firstaidkit-gui
firstaidkit-plugin-all
flawfinder
foremost
gparted
halberd
hexedit
#horst
hping3
ht
httping
hunt
iftop
iperf
iptraf-ng
irssi
john
kismet
labrea
lbd
lynis
macchanger
mc
mcabber
medusa
mutt
nano
nbtscan
nc
nc6
ncrack
nebula
net-snmp
netsniff-ng
ngrep
nikto
nmap
nmap-frontend
ntfs-3g
ntfsprogs
nwipe
openvas-client
openvas-scanner
ophcrack
p0f
packETH
pads
pcapdiff
powertop
pscan
ratproxy
rats
rkhunter
samdump2
scamper
scanmem
scapy
screen
scrub
sectool-gui
security-menus
sing
sipp
sipsak
skipfish
sleuthkit
snmpcheck
socat
splint
sqlninja
srm
ssldump
sslscan
#sucrack
tcpdump
tcpflow
tcpick
tcpjunk
tcpxtract
testdisk
unhide
unicornscan
uperf
vim-enhanced
wavemon
weplab
wget
wireshark-gnome
xmount
xprobe2
yersinia
yum-utils

%end

%post
# LXDE and LXDM configuration

# create /etc/sysconfig/desktop (needed for installation)
cat > /etc/sysconfig/desktop <<EOF
PREFERRED=/usr/bin/startlxde
DISPLAYMANAGER=/usr/sbin/lxdm
EOF

cat >> /etc/rc.d/init.d/livesys << EOF
# disable screensaver locking and make sure gamin gets started
cat > /etc/xdg/lxsession/LXDE/autostart << FOE
/usr/libexec/gam_server
@lxpanel --profile LXDE
@pcmanfm --desktop --profile LXDE
/usr/libexec/notification-daemon
FOE

# set up preferred apps 
cat > /etc/xdg/libfm/pref-apps.conf << FOE 
[Preferred Applications]
WebBrowser=midori.desktop
MailClient=redhat-sylpheed.desktop
FOE

# set up auto-login for liveuser
sed -i 's|# autologin=dgod|autologin=liveuser|g' /etc/lxdm/lxdm.conf

# Show harddisk install on the desktop
sed -i -e 's/NoDisplay=true/NoDisplay=false/' /usr/share/applications/liveinst.desktop
mkdir /home/liveuser/Desktop
cp /usr/share/applications/liveinst.desktop /home/liveuser/Desktop

# Add autostart for parcellite
cp /usr/share/applications/fedora-parcellite.desktop /etc/xdg/autostart

# this goes at the end after all other changes.
chown -R liveuser:liveuser /home/liveuser
restorecon -R /home/liveuser

EOF

%end

