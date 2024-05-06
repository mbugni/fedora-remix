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
mkdir -p /usr/local/libexec/remix

cat > /usr/local/libexec/remix/flatpak-setup << EOF_FLATPAK
# Flatpak setup commands

echo "Setting up flathub repo..."
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

echo "Sharing user Gtk settings with apps..."
flatpak override --user --filesystem=xdg-config/gtkrc:ro
flatpak override --user --filesystem=xdg-config/gtkrc-2.0:ro
flatpak override --user --filesystem=xdg-config/gtk-3.0:ro
flatpak override --user --filesystem=xdg-config/gtk-4.0:ro

EOF_FLATPAK

%end
