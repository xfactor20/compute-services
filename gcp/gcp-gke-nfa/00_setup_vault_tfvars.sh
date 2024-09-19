#!/bin/bash

# Prerequisites 

# 1. Docker is installed on the VM host or PC Client
# 2. Vault is installed on the VM host or PC Client. Reference instructions here: https://developer.hashicorp.com/vault/install 

#    Ubuntu/Debian:
#          wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
#          echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
#          sudo apt update && sudo apt install vault


# 3. Generated SSH keys exist
#    Be sure to run th following command to generate ssh private and public keys BEFORE running this script.  It will fail otherwise
#    Run the following command.  Accept all default values. Leave the passphrase blank
#
#       ssh-keygen -t rsa -b 4096 -C "vault-server-access-by-<my-email-address>"


# set environment variables for use by terraform scripts
echo "1st: Setting vault address: $VAULT_ADDR and vault token: $VAULT_TOKEN variables..."

export VAULT_ADDR='http://127.0.0.1:8200'
export VAULT_TOKEN="root"

echo "1st: The Vault address: $VAULT_ADDR. The Vault token: $VAULT_TOKEN ..."

# Step 1: Start Vault
# docker run -d --name vault-dev -p 8200:8200 vault

# Run an explicit Vault server container version
# docker run -d --name vault-dev -p 8200:8200 hashicorp/vault:1.13.3
docker run -d --name vault-dev -p 8200:8200 -e 'VAULT_DEV_ROOT_TOKEN_ID=root' hashicorp/vault:1.13.3

echo "Making sure Vault server is running prior to setting up secret keys..."

while ! curl -s "$VAULT_ADDR/v1/sys/health" | grep '"sealed":false'; do
    echo "Waiting for Vault to be ready..."
    sleep 2
done

# Step 2: Create Secrets in Vault
# vault secrets enable -path=secret kv
echo "Setting up keys on Vault server now..."
vault kv put secret/gcp/k8s_ssh_keys private_key="$(cat ~/.ssh/id_rsa)" public_key="$(cat ~/.ssh/id_rsa.pub)"
echo "DONE: Setting up keys on Vault repository command..." 

# Step 3: Create Terraform Variables
tf_vars_file="terraform.tfvars"

echo "Creating terraform variables file: $tf_vars_file" 

cat > $tf_vars_file <<EOF
gcp_project_id = "$(gcloud config get-value project)"
gcp_region     = "us-central1"
gcp_zone       = "us-central1-a"
vault_address  = "$VAULT_ADDR"
vault_token    = "$VAULT_TOKEN"
EOF

if [ -e "$fileName" ]; then
    echo "The file ' $tf_vars_file' exists."
    echo "Vault server and Terraform variables are set up and ready to use."
else
    echo "ERROR: The file ' $tf_vars_file' does not exist.  Please review and fix the process.  Once resolved, run this part again to set up Terraform variables file"
fi

                                                                                
