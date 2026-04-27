#!/usr/bin/bash
#
# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (c) 2026 Massimiliano Bugni
#
# session-setup: interactive session configuration

if [ -x /usr/bin/flatpak ]; then
    echo "Inject KDE Gtk settings into flatpak apps"
    flatpak override --user --filesystem=xdg-config/gtkrc:ro
    flatpak override --user --filesystem=xdg-config/gtkrc-2.0:ro
    flatpak override --user --filesystem=xdg-config/gtk-3.0:ro
    flatpak override --user --filesystem=xdg-config/gtk-4.0:ro
fi

[ "$REMIX_SYSTEM_LIFECYCLE" = "live" ] || exit 0

# Query xdg-user-dir directory because different languages
desktop_dir=$(xdg-user-dir DESKTOP)

# Check if installer is already configured
[ -e $desktop_dir/livesys-install.desktop ] && exit 0

echo "Add installer icon to liveuser desktop"
cp -a /usr/share/applications/livesys-install.desktop $desktop_dir/

# Make installer icon executable to disable KDE security warning
chmod +x $desktop_dir/livesys-install.desktop
