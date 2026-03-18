#!/usr/bin/bash
# -------------------------------------------------------------------------
# Post-installation cleanup for Fedora
# Run inside the target system (chroot)
# -------------------------------------------------------------------------

# Rewrite grub2 BLS entries to address target system
rm -f /boot/loader/entries/*.conf
/bin/kernel-install add $(uname -r) /lib/modules/$(uname -r)/vmlinuz

# Remove live-specific resources
/usr/bin/systemctl disable livesys-boot-setup.service || true
rm -f /etc/systemd/system/livesys-boot-setup.service
rm -rf /usr/local/share/livesys
