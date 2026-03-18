#!/usr/bin/bash
#
# session-setup: configure session for liveuser

# Query xdg-user-dir directory because different languages
DESKTOP_DIR=$(xdg-user-dir DESKTOP)

# Check if installer is already configured
[ -e $DESKTOP_DIR/livesys-install.desktop ] && exit 0

# Add installer icon to liveuser desktop
cp -a /usr/share/applications/*-install.desktop $DESKTOP_DIR/

# Make installer icon executable to disable KDE security warning
chmod +x $DESKTOP_DIR/*-install.desktop
