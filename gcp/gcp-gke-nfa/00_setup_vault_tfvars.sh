#!/bin/bash

# IMPORTANT!!! Prerequisite - be sure to run th following command to generate ssh private and public keys BEFORE running this script.  It will fail otherwise
# Run the following command.  Accept all default values. Leave the passphrase blank
#
#       ssh-keygen -t rsa -b 4096 -C "vault-server-access-by-<my-email-address>"

# Step 1: Start Vault
# Run an explicit Vault server container version in development mode
docker run -d --name vault-dev -p 8200:8200 -e 'VAULT_DEV_ROOT_TOKEN_ID=root' hashicorp/vault:1.13.3

# docker run -d --name vault-dev -p 8200:8200 hashicorp/vault:1.13.3
# docker run -d --name vault-dev -p 8200:8200 vault

# Set environment variables to be referenced by terraform scripts
export VAULT_ADDR='http://127.0.0.1:8200'
export VAULT_TOKEN="root"

# Step 2: Create Secrets in Vault
vault secrets enable -path=secret kv
vault kv put secret/gcp/k8s_ssh_keys private_key="$(cat ~/.ssh/id_rsa)" public_key="$(cat ~/.ssh/id_rsa.pub)"

# Step 3: Create Terraform Variables
cat > terraform.tfvars <<EOF
gcp_project_id = "$(gcloud config get-value project)"
gcp_region     = "us-central1"
gcp_zone       = "us-central1-a"
vault_address  = "$VAULT_ADDR"
vault_token    = "$VAULT_TOKEN"
EOF

echo "Vault server and Terraform variables are set up and ready to use."
