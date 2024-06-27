
#!/bin/bash


# Set the output file names
TENANT_ID_FILE="tenant_id.txt"
SUBSCRIPTION_NAME_FILE="subscription_name.txt"
SUBSCRIPTION_ID_FILE="subscription_id.txt"
SVC_PRINCIPAL_FILE="svc_principal.txt"
CONFIG_DIR="$HOME/config"

# Create the configuration directory and set working path to the same
mkdir "$CONFIG_DIR"
cd /d "$CONFIG_DIR"

# Install package for processing JSON files (svc_principal.txt)
sudo apt-get install jq

# Get the Tenant ID, subscription name and ID
az account show --query="tenantId" --output tsv > "$TENANT_ID_FILE"
az account show --query name --output tsv > "$SUBSCRIPTION_NAME_FILE"
az account show --query id --output tsv > "$SUBSCRIPTION_ID_FILE"

# Set the environment variables
export SUBS_ID=$(cat "$SUBSCRIPTION_ID_FILE")
export TENANT_ID=$(cat "$TENANT_ID_FILE")
export MSYS_NO_PATHCONV=1

# Set the active subscription
az account set --subscription "$SUBS_ID"

# Create service principal for role-based access control (RBAC)
az ad sp create-for-rbac --role Contributor --scopes /subscriptions/${SUBS_ID} > "$SVC_PRINCIPAL_FILE"

# Read the file contents
arm_content=$(cat "$SVC_PRINCIPAL_FILE")

# Parse the JSON data using jq
APP_ID=$(echo "$arm_content" | jq -r '.appId')
PASSWORD=$(echo "$arm_content" | jq -r '.password')

# Set the environment variables
export ARM_CLIENT_ID="$APP_ID"
export ARM_CLIENT_SECRET="$PASSWORD"
