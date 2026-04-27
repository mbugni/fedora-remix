#!/usr/bin/bash
#
# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (c) 2026 Massimiliano Bugni
#
# functions: common calls

function execute_action() {
    local script="${REMIX_ACTIONABLE_DIR}/action/$1-$2.sh"

    # Check if readable file
    [ -r "$script" ] || return 0
    
    # Execute the script in a separate sub-shell
    $script
    local exit_code=$?
    if [ ${exit_code} -ne 0 ]; then
        echo "WARN: ${script} exited with code ${exit_code}"
        exit $exit_code
    fi
}
