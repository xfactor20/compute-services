#!/bin/bash

UNI_LOG="/var/log/00-uninode-install.log"
uni_log() {
  echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> $UNI_LOG
}

adduser llamauser
dnf install -y epel-release
amazon-linux-extras install -y epel

uni_log "1.0  Create and Secure Admin User... "

mkdir /home/llamauser/build
mkdir /home/llamauser/.ssh
chmod 700 /home/llamauser/.ssh
tee /home/llamauser/.ssh/authorized_keys <<"KEYEOF" 
ecdsa-sha2-nistp521 ###SSH PRIVATEKEY###
KEYEOF
chmod 600 /home/llamauser/.ssh/authorized_keys
chown -R llamauser: /home/llamauser/.ssh/

uni_log "2.0  Add Admin User to local Sudoers: "
chmod u+w /etc/sudoers.d/90-cloud-init-users
echo "llamauser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/90-cloud-init-users
chmod u-w /etc/sudoers.d/90-cloud-init-users

uni_log "3.0 Installing AWS EC2 Instance connect: "
dnf install ec2-instance-connect -y

uni_log "4.0 Resetting all ownership on adminuser directory"
chown -R llamauser: /home/llamauser

uni_log "5.0 Completed Uni-Node Base Build"

uni_log "6.0 Install Personalization"
#!/bin/bash
LLAMA_LOG="/var/log/01-llama-install.log"
llama_log() {
  echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> $LLAMA_LOG
}

llama_log "1.0 Install Specific Dependencies"
# Basic tools
dnf install -y net-tools iftop atop jq htop git-core git
# Dependencies for llama.cpp
dnf install -y python3 g++ make python3-pip npm
dnf install -y gcc gcc-c++ kernel-devel
dnf install -y make automake cmake
llama_log "2.0 Update and upgrade all packages..."
dnf update -y
dnf upgrade -y

llama_log "3.0 Set Local Passwords"
yes myc00lpassword | passwd llamauser
yes myc00lpassword | passwd ubuntu
yes myc00lpassword | passwd root

llama_log "4.0 Create local log file destination for nodeadmin"
mkdir -p /home/llamauser/logs
chown -R llamauser:llamauser /home/llamauser/logs

llama_log "###DONE### END 01_base_customization DEPENDENCY BUILD"
###############################################################

LLAMA_SCRIPT_TARGET="/var/lib/cloud/scripts/per-boot/llamacpp.sh"

llama_log "1.0 Creating the .ENV file for the LLama Node Service to /usr/local/etc/llama.cfg"
cat <<LLAMAENVEOF > /usr/local/etc/llama.cfg
MODEL_URL="https://huggingface.co/TheBloke"
MODEL_COLLECTION="Llama-2-7B-Chat-GGUF"
MODEL_FILE_NAME="llama-2-7b-chat.Q5_K_M.gguf"
MODEL_HOST=0.0.0.0
MODEL_PORT=8080
GPU_LAYERS=20
NODE_ADMIN=llamauser
LLAMA_RELEASE=https://github.com/ggerganov/llama.cpp/archive/refs/tags/b3242.tar.gz
LLAMA_INSTALL_DIR=/usr/local/src/llama.cpp
LLAMA_BIN_DIR=/usr/local/bin
LLAMA_SERVICE_FILE=/etc/systemd/system/llama.service
LLAMA_CONFIG_FILE=/usr/local/etc/llama.cfg
LLAMA_LOG_FILE=/var/log/llama_setup.log
LLAMAENVEOF
chown -R llamauser:llamauser /usr/local/etc/llama.cfg

# use single quotes around heredoc to avoid variable expansion
llama_log "2.0 Creating the llamacpp.sh script file in $LLAMA_SCRIPT_TARGET"
source /usr/local/etc/llama.cfg
cat > $LLAMA_SCRIPT_TARGET <<'MODELEOF' 
#!/bin/bash
source /usr/local/etc/llama.cfg
PATH=/usr/local/cuda/bin:$PATH
LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH

log() {
  echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> $LLAMA_LOG_FILE
}
log "Starting llama.cpp service setup..."
log "Removing and reinstalling llama.cpp..."
rm -rf $LLAMA_INSTALL_DIR
rm -rf "$LLAMA_BIN_DIR/llama-server"

log "Removing old systemd service if it exists..."
systemctl stop llama.service
systemctl disable llama.service
rm -f $LLAMA_SERVICE_FILE


# From Release
mkdir $LLAMA_INSTALL_DIR
wget -O $LLAMA_INSTALL_DIR/llama.tar.gz $LLAMA_RELEASE
tar -xvf $LLAMA_INSTALL_DIR/llama.tar.gz -C $LLAMA_INSTALL_DIR --strip-components=1
rm -f $LLAMA_INSTALL_DIR/llama.tar.gz

log "Compiling llama.cpp with CUDA support..."
cd $LLAMA_INSTALL_DIR
cmake -B build -DGGML_CUDA=1 -DCMAKE_CUDA_FLAGS="-g -lineinfo"
cmake --build build --config Release
cp "$LLAMA_INSTALL_DIR/build/bin/llama-server" "$LLAMA_BIN_DIR/llama-server"
chown -R $NODE_ADMIN:$NODE_ADMIN $LLAMA_BIN_DIR/llama-server


log "Downloading model file..." 
wget -O $LLAMA_INSTALL_DIR/models/$MODEL_FILE_NAME $MODEL_URL/$MODEL_COLLECTION/resolve/main/$MODEL_FILE_NAME
chown -R $NODE_ADMIN:$NODE_ADMIN $LLAMA_INSTALL_DIR

log "Creating new systemd service file..."
cat << EOFLLAMA > $LLAMA_SERVICE_FILE
[Unit]
Description=llama.cpp Service
After=network.target

[Service]
EnvironmentFile=$LLAMA_CONFIG_FILE
ExecStart=$LLAMA_BIN_DIR/llama-server -m $LLAMA_INSTALL_DIR/models/$MODEL_FILE_NAME --host $MODEL_HOST --port $MODEL_PORT --n-gpu-layers $GPU_LAYERS 
WorkingDirectory=$LLAMA_INSTALL_DIR
Restart=always
User=$NODE_ADMIN
Group=$NODE_ADMIN

[Install]
WantedBy=multi-user.target
EOFLLAMA
log "New service file created."

log "Reloading systemd, enabling, and starting the new service..."
systemctl daemon-reload
systemctl enable llama.service
systemctl start llama.service
log "Status: $(systemctl status llama.service)"

log "llama.cpp service setup completed successfully."
MODELEOF

chown llamauser:llamauser $LLAMA_SCRIPT_TARGET
chmod +x $LLAMA_SCRIPT_TARGET

llama_log "###DONE###  END OF LLAMA-CPP SCRIPT INSTALLATION"

###############################################################

llama_log "1.0 Checking prerequisites from https://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html#pre-installation-actions"
llama_log "lspci inspection: $(lspci | grep -i nvidia)" 
llama_log "OS Version: $(cat /etc/*release | grep PRETTY_NAME)" 
llama_log "OS Architecture:  $(uname -r)" 
llama_log "gcc inspection:  $(gcc --version | grep gcc)" 

llama_log "2.0 Driver Installation (using network repo and package manager) from https://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html#amazon" 
dnf -y install kernel-devel-$(uname -r) kernel-headers-$(uname -r) kernel-modules-extra-$(uname -r)
dnf config-manager --add-repo https://developer.download.nvidia.com/compute/cuda/repos/amzn2023/x86_64/cuda-amzn2023.repo
dnf -y clean expire-cache
dnf -y module install nvidia-driver:latest-dkms
dnf -y install cuda-toolkit
dnf -y install nvidia-gds

llama_log "3.0 Updating PATH and LD_LIBRARY_PATH..."
`echo 'export PATH=/usr/local/cuda-12.6/bin:$PATH' >> /home/llamauser/.bashrc`
`echo 'export LD_LIBRARY_PATH=/usr/local/cuda-12.6/lib64:$LD_LIBRARY_PATH' >> /home/llamauser/.bashrc`

llama_log "4.0 Verifying Installation..."
llama_log "nvidia-smi: $(/usr/bin/nvidia-smi)"
llama_log "CUDA nvcc:  $(/usr/local/cuda/bin/nvcc --version)" 

llama_log "###DONE### Rebooting system to apply changes..."
reboot now