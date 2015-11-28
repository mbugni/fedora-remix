## f22-kde-remix.ks

%include f22-kde-desktop.ks
%include f22-base-remix.ks

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
ffmpegthumbs
k3b
k3b-extras-freeworld
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

