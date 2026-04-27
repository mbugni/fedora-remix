#!/usr/bin/bash
#
# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (c) 2026 Massimiliano Bugni
#
# system-setup-user-live: ensure liveuser

[ "$(id --user --name liveuser)" = "liveuser" ] && exit 0

echo '--- Setup liveuser'
## Add liveuser user with no passwd
useradd --comment "Live System User" --create-home --shell /usr/bin/bash liveuser
passwd -d liveuser > /dev/null
usermod -aG audio,video,wheel liveuser > /dev/null

# Create config directory, if not exists
mkdir /home/liveuser/.config

# Disable automount of 'known' devices
# https://bugzilla.redhat.com/show_bug.cgi?id=2073708
cat > /home/liveuser/.config/kded_device_automounterrc << AUTOMOUNTER_EOF
[General]
AutomountEnabled=false
AutomountOnLogin=false
AutomountOnPlugin=false
AUTOMOUNTER_EOF

echo 'Finish liveuser setup'
## Make sure to set the right permissions for liveuser
chown -R liveuser:liveuser /home/liveuser
