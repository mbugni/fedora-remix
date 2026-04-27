#!/usr/bin/bash
#
# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (c) 2026 Massimiliano Bugni
#
# system-finalize: remove unnecessary stuff, if present

[ "$REMIX_SYSTEM_LIFECYCLE" = 'installed' ] || exit 0

[ -e /.kconfig ] && rm -f /.kconfig
[ -e /.profile ] && rm -f /.profile

function dnf_remove_low_priority() {
    ionice -c 2 -n 5 nice -n 15 dnf remove --assumeyes --cacheonly --disablerepo='*' "$@"
}

rpm -q anaconda-core &> /dev/null
if [ $? -eq 0 ]; then
    echo '--- Removing Anaconda OS installer'
    dnf_remove_low_priority "anaconda*" dracut-live dracut-squash
    if [ $? -eq 0 ]; then
        rm -rf /etc/anaconda
        rm -rf /var/log/anaconda
    else
        echo 'Anaconda OS installer cleanup failed'
    fi
fi

[ "$REMIX_SYSTEM_RUNTIME" = 'physical' ] || exit 0

rpm -q qemu-guest-agent &> /dev/null
if [ $? -eq 0 ]; then
    echo '--- Removing virtualization agents'
    dnf_remove_low_priority qemu-guest-agent spice-vdagent
    [ $? -eq 0 ] || echo 'Virtualization agents cleanup failed'
fi
