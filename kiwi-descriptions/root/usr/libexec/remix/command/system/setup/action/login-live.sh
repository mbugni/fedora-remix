#!/usr/bin/bash
#
# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (c) 2026 Massimiliano Bugni
#
# system-setup-login-live: live system configuration

function create_sddm_autologin() {
cat > /etc/sddm.conf <<- SDDM_EOF
    [Autologin]
    User=liveuser
    Session=plasma.desktop
SDDM_EOF
}

if [ "$(systemctl is-enabled sddm.service)" = 'enabled' ]; then
    echo '--- Set up autologin for sddm'
    if [ -f /etc/sddm.conf ]; then
        sed -i 's/^#User=.*/User=liveuser/' /etc/sddm.conf
        sed -i "s/^#Session=.*/Session=plasma.desktop/" /etc/sddm.conf
    else
        create_sddm_autologin
    fi
fi
