#!/bin/bash

# Check if running Ubuntu 24.04
if grep -q 'VERSION_ID="24.04"' /etc/os-release; then
    echo "Ubuntu 24.04 detected."

    echo "Disabling AppArmor restriction on unprivileged user namespaces..."
	
    # Set the value immediately
    sudo sysctl -w kernel.apparmor_restrict_unprivileged_userns=0

    # Persist the setting across reboots
    echo 'kernel.apparmor_restrict_unprivileged_userns = 0' | sudo tee /etc/sysctl.d/20-apparmor-donotrestrict.conf > /dev/null

    # Apply all sysctl settings
    sudo sysctl --system

    echo "AppArmor restriction disabled."
else
    echo "This script is intended for Ubuntu 24.04 only."
fi
