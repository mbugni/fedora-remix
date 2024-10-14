#!/usr/bin/bash
#
# machine: system settings

system_product_name="$(dmidecode --string system-product-name)"
if [ "$system_product_name" == "HP 250 G8 Notebook PC" ]; then
    # When closing laptop lid airplane mode comes on and won't go off:
    # https://bugzilla.redhat.com/show_bug.cgi?id=1628353
    # https://askubuntu.com/questions/965595/why-does-airplane-mode-keep-toggling-on-my-hp-laptop-in-ubuntu-18-04
    echo "HP 250 G8 - Fix airplane mode when closing laptop lid"
    setkeycodes e057 240 e058 240
fi
