#fedora-livedvd-jam-kde.ks
# With KDE Desktop

# Fedora Jam: For Musicians and audio enthusiasts
# Fedora Jam is a spin for anyone interested in creating 
# music 
# Web: https://fedoraproject.org/wiki/Fedora_jam
# Web: insert spinspacke when created

# Maintainer: Jørn Lomax <northlomax@gmail.com>
#             https://fedoraproject.org/wiki/User:jvlomax
#             Brendan Jones <brendan.jones.it@gmail.com>

%include fedora-livecd-kde.ks

# DVD size partition
part / --size 10240 --fstype ext4

#enable threaded irqs
bootloader --append="threadirqs"

%packages

#alsa
alsa-firmware
alsa-tools
alsa-utils
alsamixergui
alsa-plugins-jack
alsa-plugins-pulseaudio
alsa-plugins-usbstream
alsa-plugins-samplerate
alsa-plugins-upmix
alsa-plugins-vdownmix
a2jmidid
aj-snapshot

#jack 
jack-audio-connection-kit
jack-audio-connection-kit-dbus
qjackctl
jackctlmmc
ffado

#pulse
pulseaudio-module-jack
pavucontrol

#midi
qsynth
fluidsynth
fluid-soundfont-gm
fluidsynth-dssi
timidity++
qmidiarp
vmpk
harmonyseq

#synthesis
hydrogen
bristol
monobristol
zynaddsubfx
yoshimi
swami
Add64
synthv1
samplv1
drumkv1
ams

#guitar
rakarrack
guitarix
tuxguitar
sooperlooper

#recodring and DAW
audacity
ardour3
rosegarden4
seq24
muse
qtractor
non-session-manager
non-daw
non-sequencer
non-mixer

# audio-plugins
calf
dssi
jack-rack
ladspa

#ladpsa plugins
ladspa-amb-plugins
ladspa-autotalent-plugins
ladspa-blop-plugins
ladspa-cmt-plugins
ladspa-fil-plugins
ladspa-mcp-plugins
ladspa-rev-plugins
ladspa-swh-plugins
ladspa-tap-plugins
ladspa-vco-plugins

#lv2 plugins
lv2
lv2-avw-plugins
lv2-fil-plugins
lv2-invada-plugins
lv2-kn0ck0ut
lv2-ll-plugins
lv2-swh-plugins
lv2-vocoder-plugins
lv2-zynadd-plugins
lv2dynparam
lv2-abGate
lv2-c++-tools 
lv2-samplv1
lv2-synthv1
lv2-drumkv1
lv2-triceratops
lv2-newtonator
lv2-x42-plugins
lv2-fomp-plugins
lv2-sorcer
lv2-fabla
lv2-artyfx-plugins

#dssi
nekobee-dssi
whysynth-dssi
xsynth-dssi
hexter-dssi

zynjacku 
zita-at1
zita-rev1

#sound analasys, none of these are packaged yet
#praat bug_id=666656
#friture

#writing & publishing
emacs
emacs-color-theme
vim
nano
mscore
lilypond
frescobaldi
mup

#audio utilities
jamin
lash
jack_capture
jaaa
jmeters
qastools
arpage
realTimeConfigQuickScan
rtirq
#patchage
#ladish #not packaged yet
japa
radium-compressor

#streaming
idjc

# fedora jam theming (to be customized)
kfaenza-icon-theme
fedora-jam-backgrounds
fedora-jam-kde-theme

#Misc. Utils
screen
shutter
-ksnapshot
multimedia-menus
kernel-tools


#Include Mozilla Firefox and Thunderbird
firefox
thunderbird

#remove packages not need
#-kdesdk-umbrello
#-kdesdk-kcachegrindy

#-kdesdk-kompare
#-kdepim

%end

%post

#setup kickoff favorites
/bin/mkdir -p /etc/skel/.config

JAMFAVORITES=/usr/share/applications/firefox.desktop,/usr/share/applications/qjackctl.desktop,/usr/share/applications/qtractor.desktop,/usr/share/applications/frescobaldi.desktop,/usr/share/applications/org.kde.konsole.desktop,/usr/share/applications/kde4/dolphin.desktop,/usr/share/applications/systemsettings.desktop,/usr/share/applications/pavucontrol.desktop,/usr/share/applications/kde4/kfmclient_html.desktop,/usr/share/applications/kde4/Kontact.desktop,/usr/share/applications/kde4/ktp-contactlist.desktop
JAMFAVORITESLIVE=/usr/share/applications/liveinst.desktop,$JAMFAVORITES

cat <<EOF  >> /etc/skel/.config/kickoffrc
[Favorites]
FavoriteURLs=$JAMFAVORITES
EOF

# Override fedora-live-kde-base.ks settings
sed -i /etc/rc.d/init.d/livesys -res"#^(FavoriteURLs=).*#\1${JAMFAVORITESLIVE}#"


cat >> /etc/rc.d/init.d/livesys << EOF
/usr/sbin/usermod -a -G jackuser,audio liveuser
EOF

%end


