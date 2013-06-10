## f18-kde-desktop.ks

%include f18-kde-desktop.ks
%include f18-common-remix.ks

part / --size 4096

%packages

### The KDE-Desktop

# Unwanted stuff
-libreoffice-kde

amarok
digikam
k3b
k3b-extras-freeworld
kamoso
kamera
kde-print-manager
kde-plasma-ktorrent
kdegraphics-thumbnailers
kscd
kwebkitpart
skanlite

# Internet
icedtea-web
pidgin

# Multimedia
kffmpegthumbnailer
gnash-plugin
vlc
npapi-vlc

# Office
libreoffice
libreoffice-langpack-it

%end


%post

echo ""
echo "**************"
echo "POST KDE REMIX"
echo "**************"

# Default apps: vlc (instead of dragonplayer)
grep kde4-dragonplayer.desktop /usr/share/kde-settings/kde-profile/default/share/applications/defaults.list \
	| sed 's/kde4-dragonplayer.desktop/vlc.desktop/g' >> /usr/local/share/applications/mimeapps.list

%end

