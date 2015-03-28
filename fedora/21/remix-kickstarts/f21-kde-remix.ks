## f21-kde-remix.ks

%include f21-kde-desktop.ks
%include f21-base-remix.ks

part / --size 4096 --fstype ext4

%packages

# Unwanted stuff
-libreoffice-kde

# Graphics
digikam
guvcview
# kamera
kdegraphics-thumbnailers
kwebkitpart
skanlite

# Internet
# icedtea-web
kde-plasma-ktorrent
pidgin

# Multimedia
clementine
# gnash-plugin
k3b
k3b-extras-freeworld
kffmpegthumbnailer
vlc
npapi-vlc

# Office
@libreoffice
libreoffice-langpack-it

# Settings
kde-print-manager

%end


%post

echo ""
echo "**************"
echo "POST KDE REMIX"
echo "**************"

# Default apps: vlc (instead of dragonplayer)
grep kde4-dragonplayer.desktop /usr/share/kde-settings/kde-profile/default/share/applications/defaults.list \
	| sed 's/kde4-dragonplayer.desktop/vlc.desktop/g' >> /usr/local/share/applications/mimeapps.list
# Default apps: clementine (instead of amarok)
grep kde4-amarok.desktop /usr/share/kde-settings/kde-profile/default/share/applications/defaults.list \
	| sed 's/kde4-amarok.desktop/clementine.desktop/g' >> /usr/local/share/applications/mimeapps.list


%end

