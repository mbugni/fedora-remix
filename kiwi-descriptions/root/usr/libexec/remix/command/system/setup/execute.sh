#!/usr/bin/bash
#
# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (c) 2026 Massimiliano Bugni
#
# system-setup: prepare system for human usage

execute_action "machine"    "${REMIX_MACHINE_MANUFACTURER}"
execute_action "user"       "${REMIX_SYSTEM_LIFECYCLE}"
execute_action "login"      "${REMIX_SYSTEM_LIFECYCLE}"
execute_action "seat"       "${REMIX_SYSTEM_LIFECYCLE}"
