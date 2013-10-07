## f19-openbox-desktop.ks

%include f19-base-desktop.ks

%packages

# Unwanted stuff
-gnome*

adwaita-gtk*-theme
lightdm
lightdm-gtk
openbox
obconf
fbpanel
gnome-icon-theme
gnome-icon-theme-symbolic
network-manager-applet
notification-daemon
polkit-gnome
terminator
vim-X11
xdg-utils
xscreensaver-base

%end


%post

echo ""
echo "********************"
echo "POST OPENBOX DESKTOP"
echo "********************"

# create /etc/sysconfig/desktop (needed for installation)
cat > /etc/sysconfig/desktop << EOF_DESKTOP
PREFERRED=/usr/bin/openbox-session
DISPLAYMANAGER=/usr/sbin/lightdm
EOF_DESKTOP

cat >> /etc/rc.d/init.d/livesys << EOF_LIVESYS
# set up lightdm autologin
sed -i 's/^#autologin-user=.*/autologin-user=liveuser/' /etc/lightdm/lightdm.conf
sed -i 's/^#autologin-user-timeout=.*/autologin-user-timeout=0/' /etc/lightdm/lightdm.conf
#sed -i 's/^#show-language-selector=.*/show-language-selector=true/' /etc/lightdm/lightdm-gtk-greeter.conf

# Show harddisk install on the desktop
sed -i -e 's/NoDisplay=true/NoDisplay=false/' /usr/share/applications/liveinst.desktop
mkdir /home/liveuser/Desktop
cp /usr/share/applications/liveinst.desktop /home/liveuser/Desktop
EOF_LIVESYS

# override default gnome settings
cat >> /usr/share/glib-2.0/schemas/org.gnome.remix.gschema.override << EOF_GNOME_SETTINGS
[org.gnome.desktop.interface]
font-name='Sans 10'
document-font-name='Sans 10'
monospace-font-name='Monospace 10'
menus-have-icons=true

[org.gnome.desktop.wm.preferences]
titlebar-font='Sans Bold 9'

[org.gnome.desktop.background]
show-desktop-icons=true

[org.gnome.nautilus.desktop]
font='Sans Bold 9'
EOF_GNOME_SETTINGS

glib-compile-schemas /usr/share/glib-2.0/schemas

# Configure openbox autostart
mkdir -p /etc/skel/.config/openbox
cat > /etc/skel/.config/openbox/autostart << EOF_OPENBOX_AUTOSTART
/usr/libexec/polkit-gnome-authentication-agent-1 &
/usr/libexec/notification-daemon &
xscreensaver &
fbpanel &
EOF_OPENBOX_AUTOSTART

# Configure fbpanel default profile
mkdir -p /etc/skel/.config/fbpanel
cat > /etc/skel/.config/fbpanel/default << EOF_FBPANEL_DEFAULT
Global {
	edge = bottom
	allign = left
	margin = 0
	widthtype = percent
	width = 100
	heighttype = pixel
	height = 22
	roundcorners = false 
	transparent = false
	tintcolor = #ffffff
	alpha = 39
}

Plugin {
    type = space
    config {
        size = 2
    }
}

Plugin {
    type = menu
    config {
		IconSize = 22
		icon = fedora-logo-icon
		name = Applications
		systemmenu {
		}
		separator {
		}
		menu {
		    name = Computer
		    icon = computer
		    item {
				name = Reboot
				icon = system-reboot
				action = reboot
		    }
		    item {
				name = Shutdown
				icon = system-shutdown
				action = poweroff
		    }
		    item {
				name = Logout
				icon = system-log-out
				action = /usr/libexec/fbpanel/xlogout
		    }
		}
    }
}

Plugin {
    type = space
    config {
        size = 5
    }
}

Plugin {
    type = wincmd
    config {
        icon = user-desktop
        tooltip = Left click to iconify all windows. Middle click to shade them.
    }
}

Plugin {
    type = space
    config {
        size = 5
    }
}

Plugin {
    type = taskbar
    expand = true
    config {
        ShowIconified = true
        ShowMapped = true
        ShowAllDesks = false
        tooltips = true
        IconsOnly = false
        MaxTaskWidth = 150
    }
}

Plugin {
    type = space
    config {
        size = 3
    }
}

Plugin {
    type = tray
}

Plugin {
    type = space
    config {
        size = 3
    }
}

Plugin {
    type = dclock
    config {
        HoursView = 24
    }
}
EOF_FBPANEL_DEFAULT

%end

