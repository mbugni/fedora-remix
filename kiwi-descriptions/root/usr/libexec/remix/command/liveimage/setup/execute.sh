#!/usr/bin/bash
#
# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (c) 2026 Massimiliano Bugni
#
# liveimage-setup: configure live image after build

[ -e /.profile ] || exit 0

echo '--- Enable system wide settings'
systemctl enable remix-system-setup.service
systemctl enable remix-system-finalize.service

if [ "$(systemctl is-enabled sddm.service)" = 'enabled' ]; then
    echo '--- Enable graphical system setup'
	systemctl --global enable remix-session-setup.service
	# Set up Flatpak
	echo "Setting up Flathub repo"
	flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
	# Avoid additional Fedora's Flatpak repos
	systemctl disable flatpak-add-fedora-repos
fi
