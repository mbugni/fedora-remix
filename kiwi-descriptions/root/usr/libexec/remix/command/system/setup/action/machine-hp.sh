#!/usr/bin/bash
#
# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (c) 2026 Massimiliano Bugni
#
# HP 250 G8: when closing laptop lid airplane mode comes on and won't go off:
#   https://bugzilla.redhat.com/show_bug.cgi?id=1628353
#   https://askubuntu.com/questions/965595/why-does-airplane-mode-keep-toggling-on-my-hp-laptop-in-ubuntu-18-04

system_product_name="$(cat /sys/class/dmi/id/product_name)"
echo "HP product detected: ${system_product_name}"
if [ "$system_product_name" = 'HP 250 G8 Notebook PC' ]; then
    echo '--- HP 250 G8 - Fix airplane mode when closing laptop lid'
    exec setkeycodes e057 240 e058 240
fi
