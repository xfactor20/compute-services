#!/bin/bash

# Function to check if Vault is installed
check_vault_installed() {
    if command -v vault >/dev/null 2>&1; then
        return 0  # Vault is installed
    else
        return 1  # Vault is not installed
    fi
}

# Function to uninstall Vault
uninstall_vault() {
    echo "Uninstalling Vault..."
    if [ -f /usr/bin/vault ]; then
        sudo rm /usr/bin/vault
        echo "Vault binary removed."
    else
        echo "Vault binary not found in /usr/local/bin."
    fi

    # Optionally remove any Vault directories if needed (like config files or data)
    if [ -d /etc/vault.d ]; then
        sudo rm -rf /etc/vault.d
        echo "Vault configuration directory removed."
    fi

    if [ -d /var/lib/vault ]; then
        sudo rm -rf /var/lib/vault
        echo "Vault data directory removed."
    fi
}

# Main script logic
if check_vault_installed; then
    echo "Vault is installed."
    uninstall_vault
else
    echo "Vault is not installed."
fi
