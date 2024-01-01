# base-flatpak.ks
#
# Defines the basics for a basic flatpak environment.

%packages --excludeWeakdeps

# Fonts
libreoffice-opensymbol-fonts

# Software
flatpak

%end

%post

echo ""
echo "POST BASE FLATPAK ************************************"
echo ""

# Manage flatpak setup
mkdir -p /usr/share/doc/flatpak-setup

cat > /usr/share/doc/flatpak-setup/setup.txt << EOF_FLATPAK
# Flatpak setup commands

## Add flathub repo
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

## Override KDE's Gtk3 settings for all apps
flatpak override --user --filesystem=xdg-config/gtk-3.0:ro

## Install Firefox
flatpak install --noninteractive --assumeyes flathub org.mozilla.firefox

EOF_FLATPAK

%end
