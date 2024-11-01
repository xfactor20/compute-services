#!/bin/bash

#User Configs
SCRIPT_HOME_USER="moruser"
SCRIPT_HOME_PASSWORD="H0lyC0wThisW0rks!"

# GitHub Source 
SCRIPT_GITHUB_BRANCH="dev"
SCRIPT_GITHUB_REPO="Lumerin-protocol/Morpheus-Lumerin-Node.git"

# Morpheus Node .env vars
SCRIPT_ETH_NODE_ADDRESS="wss://arb-sepolia.g.alchemy.com/v2/<YOUR_ALCHEMY_API_KEY_HERE"
SCRIPT_PROXY_ADDRESS_PORT="3333" #Public Port to listen for proxy traffic
SCRIPT_WEB_ADDRESS_PORT="8082" #Private port to listen for API 
SCRIPT_WEB_PUBLIC_URL="1.2.3.4" #Public IP or DNS of the server for API access
SCRIPT_OPENAI_BASE_URL="LLM_SERVER_DNS_OR_IP_ADDRESS"
SCRIPT_OPENAI_BASE_URL_PORT="8080" #Port that the OpenAI server is listening on
SCRIPT_WALLET_PRIVATE_KEY="PROVIDER_WALLET_PRIVATE_KEY" 

# Morpheus Node Model Configs
SCRIPT_MODEL_UUID="0x....." #UUID of the model 32-byte hex
SCRIPT_MODEL_NAME="NAME_OF_MODEL" #Name of the model

#######END OF SCRIPT VARS########

UNI_LOG="/var/log/00-uninode-install.log"
uni_log() {
  echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> $UNI_LOG
}

adduser $SCRIPT_HOME_USER
dnf install -y epel-release
amazon-linux-extras install -y epel

uni_log "1.0  Create and Secure Admin User... "

mkdir /home/$SCRIPT_HOME_USER/build
# OPTIONAL to setup SSH key for remote access
# mkdir /home/$SCRIPT_HOME_USER/.ssh
# chmod 700 /home/$SCRIPT_HOME_USER/.ssh
# tee /home/$SCRIPT_HOME_USER/.ssh/authorized_keys <<"KEYEOF" 
# ---CHANGEME:SSH KEY --- 
# KEYEOF
# chmod 600 /home/$SCRIPT_HOME_USER/.ssh/authorized_keys
# chown -R $SCRIPT_HOME_USER: /home/$SCRIPT_HOME_USER/.ssh/
mor_log "1.3 Set Local Passwords"
yes $SCRIPT_HOME_PASSWORD | passwd $SCRIPT_HOME_USER
yes $SCRIPT_HOME_PASSWOR | passwd ec2-user
yes $SCRIPT_HOME_PASSWOR | passwd root

uni_log "2.0  Add Admin User to local Sudoers: "
chmod u+w /etc/sudoers.d/90-cloud-init-users
echo "$SCRIPT_HOME_USER ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/90-cloud-init-users
chmod u-w /etc/sudoers.d/90-cloud-init-users

uni_log "3.0 Installing AWS EC2 Instance connect: "
dnf install ec2-instance-connect -y

uni_log "4.0 Resetting all ownership on adminuser directory"
chown -R $SCRIPT_HOME_USER: /home/$SCRIPT_HOME_USER

uni_log "5.0 Completed Uni-Node Base Build"

uni_log "6.0 Install Personalization"

MOR_LOG="/var/log/02-mor-install.log"
mor_log() {
  echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> $MOR_LOG
}

###############################################################
mor_log "0.0 Starting the Morpheus Node Setup script..."
mor_log "1.0 Install Specific Dependencies"
# Basic tools
sleep 60 # Wait for the system to settle
dnf install -y net-tools iftop atop jq htop 
dnf install -y git-core git
dnf install -y python3 g++ make python3-pip npm
dnf install -y gcc gcc-c++ kernel-devel
dnf install -y make automake cmake
mor_log "1.2 Update and upgrade all packages..."
dnf update -y
dnf upgrade -y

mor_log "1.4 Create local log file destination for nodeadmin"
mkdir -p /home/$SCRIPT_HOME_USER/logs
chown -R $SCRIPT_HOME_USER:$SCRIPT_HOME_USER /home/$SCRIPT_HOME_USER/logs
mor_log "###1.0 DONE###"

###############################################################
mor_log "2.0 Installing GoLang..." 
wget https://go.dev/dl/go1.21.11.linux-amd64.tar.gz
tar -C /usr/local -xzf go1.21.11.linux-amd64.tar.gz
export PATH=$PATH:/usr/local/go/bin
PATH=$PATH:/usr/local/go/bin
mor_log $(go version)
echo "PATH=$PATH:/usr/local/go/bin" >> /home/$SCRIPT_HOME_USER/.bashrc
echo "export PATH" >> /home/$SCRIPT_HOME_USER/.bashrc
mor_log "###2.0 DONE###"

#################################################################
mor_log "3.0 Creating the .ENV File for the Morpheus Node Setup script in /usr/local/etc/mornode_setup.cfg.."
cat <<MORENVEOF > /usr/local/etc/mornode_setup.cfg
INSTALL_DIR="/usr/local/src/mor_lumerin_node"
BIN_DIR="/usr/local/bin"
SERVICE_FILE="/etc/systemd/system/mor_lumerin_node.service"
CONFIG_FILE="/usr/local/etc/mornode.env"
GOPATH="/usr/local/go/bin"
GOCACHE="/root/.cache/go-build"
LOG_FILE="/var/log/mornode.log"
GITHUB_BRANCH=$SCRIPT_GITHUB_BRANCH
GITHUB_REPO=$SCRIPT_GITHUB_REPO
NODE_ADMIN=$SCRIPT_HOME_USER
MORENVEOF
chown -R $SCRIPT_HOME_USER:$SCRIPT_HOME_USER /usr/local/etc/mornode_setup.cfg
mor_log "###3.0 DONE###"

#################################################################
mor_log "4.0 Creating the .ENV File for the Morpheus Node Service in /usr/local/etc/mornode.env..."
echo "ETH_NODE_ADDRESS=$SCRIPT_ETH_NODE_ADDRESS" >> /usr/local/etc/mornode.env
echo "EXPLORER_API_URL=https://api-sepolia.arbiscan.io/api" >> /usr/local/etc/mornode.env
echo "DIAMOND_CONTRACT_ADDRESS=0x8e19288d908b2d9F8D7C539c74C899808AC3dE45" >> /usr/local/etc/mornode.env
echo "MOR_TOKEN_ADDRESS=0xc1664f994fd3991f98ae944bc16b9aed673ef5fd" >> /usr/local/etc/mornode.env
echo "PROXY_ADDRESS=0.0.0.0:$SCRIPT_PROXY_ADDRESS_PORT" >> /usr/local/etc/mornode.env
echo "WEB_ADDRESS=0.0.0.0:$SCRIPT_WEB_ADDRESS_PORT" >> /usr/local/etc/mornode.env
echo "WEB_PUBLIC_URL=http://$SCRIPT_WEB_PUBLIC_URL:$SCRIPT_WEB_ADDRESS_PORT" >> /usr/local/etc/mornode.env
echo "OPENAI_BASE_URL=http://$SCRIPT_OPENAI_BASE_URL:$SCRIPT_OPENAI_BASE_URL_PORT" >> /usr/local/etc/mornode.env
echo "WALLET_PRIVATE_KEY=$SCRIPT_WALLET_PRIVATE_KEY" >> /usr/local/etc/mornode.env
cat <<MOREOF >> /usr/local/etc/mornode.env
MODELS_CONFIG_PATH=/usr/local/etc/models-config.json
ENVIRONMENT=development
ETH_NODE_LEGACY_TX=false
LOG_COLOR=true
LOG_FOLDER_PATH=/home/$SCRIPT_HOME_USER/logs
LOG_LEVEL_APP=info
LOG_LEVEL_CONNECTION=info
LOG_LEVEL_PROXY=info
LOG_LEVEL_SCHEDULER=info
PROXY_STORAGE_PATH=/home/$SCRIPT_HOME_USER/logs
SYS_ENABLE=false
SYS_LOCAL_PORT_RANGE=1024 65535
SYS_NET_DEV_MAX_BACKLOG=100000
SYS_RLIMIT_HARD=524288
SYS_RLIMIT_SOFT=524288
SYS_SOMAXCONN=100000
SYS_TCP_MAX_SYN_BACKLOG=100000
MOREOF
chown -R $SCRIPT_HOME_USER:$SCRIPT_HOME_USER /usr/local/etc/mornode.env
mor_log "###4.0 DONE###"

#################################################################
mor_log "5.0 Creating the models-config.json file for the Morpheus Node Service in /usr/local/etc/models-config.json..."
cat <<MODELSEOF > /usr/local/etc/models-config.json
{
    "0x6a4813e866a48da528c533e706344ea853a1d3f21e37b4c8e7ffd5ff25779018": {
        "modelName": "llama2",
        "apiType": "openai"
    }, 
    "$SCRIPT_MODEL_UUID": {
        "modelName": "$SCRIPT_MODEL_NAME",
        "apiType": "openai",
        "apiUrl": "http://$SCRIPT_OPENAI_BASE_URL:$SCRIPT_OPENAI_BASE_URL_PORT",
    }
}
MODELSEOF
chown -R $SCRIPT_HOME_USER:$SCRIPT_HOME_USER /usr/local/etc/models-config.json
mor_log "###5.0 DONE###"

#################################################################
MOR_SCRIPT_TARGET="/home/$SCRIPT_HOME_USER/morreset.sh"
mor_log "6.0 Creating the .sh script file for the Morpheus Node Service in $MOR_SCRIPT_TARGET..."
# Use single quotes around HEREDOC to prevent variable expansion
cat > $MOR_SCRIPT_TARGET <<'MORNODEEOF' 
#!/bin/bash
source /usr/local/etc/mornode_setup.cfg 
LOG_FILE="/var/log/mor_setup.log"
log() {
  echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}
log "### START OF 03_mor_node_v0 MORPHEUS NODE INSTALLATION ##########"

###############################################################
log "01 - update path variables for go for root user" 
mkdir -p "$GOCACHE"
export GOPATH="$GOPATH"
export GOCACHE="$GOCACHE"
PATH=$PATH:/usr/local/go/bin
log "GOPATH set to $GOPATH"
log "GOCACHE set to $GOCACHE"

###############################################################
log "02 - Removing Installation and Service..."
systemctl stop mor_lumerin_node.service
systemctl disable mor_lumerin_node.service
rm -rf "$INSTALL_DIR"
rm -f "$SERVICE_FILE"

###############################################################
log "03 - Downloading update mor_lumerin_node..."
git clone -b $GITHUB_BRANCH https://github.com/$GITHUB_REPO "$INSTALL_DIR"
chown -R "$NODE_ADMIN:$NODE_ADMIN" "$INSTALL_DIR"
cd "$INSTALL_DIR"/proxy-router
go mod tidy
go build -o "$BIN_DIR/mor_lumerin_node" cmd/main.go
chown -R "$NODE_ADMIN:$NODE_ADMIN" "$BIN_DIR/mor_lumerin_node"

###############################################################
log "04 - Creating new systemd service file..."
cat << MOREOF > "$SERVICE_FILE"
[Unit]
Description=mor_lumerin_node Service
After=network.target

[Service]
EnvironmentFile=$CONFIG_FILE
ExecStart=$BIN_DIR/mor_lumerin_node
Documentation=ENVFile:$CONFIG_FILE SetupConfig:/usr/local/etc/mornode_setup.cfg
Restart=always
User=$NODE_ADMIN
Group=$NODE_ADMIN

[Install]
WantedBy=multi-user.target
MOREOF

###############################################################
log "05 - Reloading systemd, enabling, and starting the new service..."
systemctl daemon-reload
systemctl enable mor_lumerin_node.service
systemctl start mor_lumerin_node.service
sleep 15
log "Status: $(systemctl status mor_lumerin_node.service)"
log "########## END OF 03_mor_node_v0 MORPHEUS NODE INSTALLATION ##########"
MORNODEEOF
chmod +x $MOR_SCRIPT_TARGET
chown $SCRIPT_HOME_USER:$SCRIPT_HOME_USER $MOR_SCRIPT_TARGET
mor_log "###6.0 DONE###"

#################################################################
mor_log "7.0 Running the Morpheus Node Setup script..."
/home/$SCRIPT_HOME_USER/morreset.sh
mor_log "###DONE###  END OF MOR-MODE SCRIPT INSTALLATION"


# END LINUX Section 
