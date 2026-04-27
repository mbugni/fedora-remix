#!/usr/bin/bash
#
# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (c) 2026 Massimiliano Bugni
#
# system-setup-seat-live: setup live interaction

echo '--- Setup seat for live session'

if [ -f /etc/xdg/autostart/liveinst-setup.desktop ]; then
    echo 'Hide original installer actions'
    desktop-file-edit --set-key=Hidden --set-value=true /etc/xdg/autostart/liveinst-setup.desktop
fi

if [ -f /usr/share/applications/liveinst.desktop ]; then
    echo 'Unify installer reference'
    mv /usr/share/applications/liveinst.desktop /usr/share/applications/livesys-install.desktop
    desktop-file-edit --set-key=NoDisplay --set-value=false /usr/share/applications/livesys-install.desktop
fi

if [ -f /etc/xdg/autostart/org.kde.discover.notifier.desktop ]; then
    echo 'Disable plasma-discover-notifier'
    desktop-file-edit --set-key=Hidden --set-value=true /etc/xdg/autostart/org.kde.discover.notifier.desktop
fi

if [ -d /usr/share/cockpit/anaconda-webui ]; then
    echo 'Disable Anaconda WebUI'
    mv /usr/share/cockpit/anaconda-webui /usr/share/cockpit/anaconda-webui-disabled
fi
