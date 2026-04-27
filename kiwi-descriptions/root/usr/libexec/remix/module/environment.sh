#!/usr/bin/bash
#
# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (c) 2026 Massimiliano Bugni
#
# environment: exports system variables

if [ -z "${REMIX_SYSTEM_LIFECYCLE}" ]; then
    if grep -q "rd.live.image" /proc/cmdline; then
        export REMIX_SYSTEM_LIFECYCLE="live"
    else
        export REMIX_SYSTEM_LIFECYCLE="installed"
    fi
fi

if [ -z "${REMIX_SYSTEM_RUNTIME}" ]; then
    if systemd-detect-virt -q; then
        export REMIX_SYSTEM_RUNTIME="virtual"
    else
        export REMIX_SYSTEM_RUNTIME="physical"
    fi
fi

[ -n "${REMIX_MACHINE_MANUFACTURER}" ] || \
    export REMIX_MACHINE_MANUFACTURER=$(cat /sys/class/dmi/id/sys_vendor | tr '[:upper:]' '[:lower:]')

[ -n "${REMIX_DISTRO_NAME}" ] || \
    export REMIX_DISTRO_NAME=$(grep "^ID=" /etc/os-release | cut -d'=' -f2-)
