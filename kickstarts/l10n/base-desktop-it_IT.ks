# base-desktop-it_IT.ks
#
# Defines the basics for a desktop with italian localization support.

lang --addsupport=it_IT.UTF-8 it_IT.UTF-8
keyboard --xlayouts=it --vckeymap=it
timezone Europe/Rome

%packages --excludeWeakdeps

glibc-langpack-it
hunspell-it
langpacks-it

%end

%post

echo ""
echo "POST BASE DESKTOP it_IT ******************************"
echo ""

# Use italian locale in live image
cat >> /var/lib/livesys/livesys-session-extra << EOF_LIVESYS
# Force italian keyboard layout (rhb #982394)
localectl set-locale it_IT.UTF-8
localectl set-x11-keymap it
localectl set-keymap it

# Environment variable for Wayland
export XKB_DEFAULT_LAYOUT=it
EOF_LIVESYS

%end
