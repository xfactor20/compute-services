# Linux VM Provisioning and Azure Kubernetes Service (AKS) setup via Terraform


## Terraform-Azure-AKS-Linux-VM
Deploy an Azure Kubernetes Service (AKS) cluster with Linux virtual machines using Terraform.

## Requirements
* Terraform v1.0.x
* Azure subscription and a valid account for authentication
* Azure CLI (`az` command-line tool)

## Pre-configuration

Ensure that you have Terraform installed. If not, you may [reference the official Terraform documentation for installation](https://developer.hashicorp.com/terraform/install)

```
which terraform
```

This section defines and configures parameter variables required for the `Setup and Configuration` section

1.	Azure Account Setup
o	Go to https://portal.azure.com and log on with your account

o	Install the Microsoft Authenticator for Two-Factor Authentication (2FA)

2.	Azure Command-Line Interface (CLI) Session
o	On your Azure portal session, click on the "command shell" icon in the toolbar at the top of the screen to start an Azure Cloud Shell session.

NOTES: When starting the CLI, select the Bash option
      Instructions to Start Azure CLI session: https://learn.microsoft.com/en-us/azure/cloud-shell/get-started/classic?tabs=azurecli

3.	Azure CLI Configuration - In the Cloud Shell session, run these commands to get parameter information required for cloud host provisioning and AKS configuration by Terraform:
```
      1.	mkdir projects/mln_aks
      2.    cd projects/mln_aks
      3.    git clone https://github.com/xfactor20/compute-services.git
      3.	cd compute-services/vm
      4.	chmod +x mln_env_config.sh
      5.	./mln_env_config.sh
```
4.	Generate an SSH key pair using this command.  Accept all default options.
```
      ssh-keygen -t rsa -m PEM -b 4096 -C mln_aks_azure@myserver
```

## Usage

### Step 1: Set working directory
On your Cloud Shell Terminal, from the above `Pre-Configuration` step, do as follows to set your workspace directory:

```bash
cd /home/[$(USERNAME)/projects/mln_aks/compute-services/vm
```

### Step 2: Create a new Azure resource group
Create a new Azure resource group for your AKS deployment. Replace `<RESOURCE_GROUP_NAME>` with a unique name.  Replace `<REGION>` with the desired Azure region, such as `eastus`, `westus2`, or `northcentralus`. Then run the following command:

```bash
az group create --name <RESOURCE_GROUP_NAME> --location <REGION>
```

### Step 3: Initialize Terraform
Initialize your working directory and fetch the required Azure provider plugins:

```bash
terraform init
```

### Step 4: Configure variables
Make certain these variables in the file `terraform.tfvars` are set as environment variables within your Cloud Shell environment:

```hcl
# Define your Azure subscription information
azure_subscription_id = "$(AZURE_SUBSCRIPTION_ID)"
azure_tenant_id       = "$(AZURE_TENANT_ID)"
azure_client_id       = "$(AZURE_CLIENT_ID)"
azure_client_secret   = "$(AZURE_CLIENT_SECRET)"

# Set the desired AKS cluster settings
aks_cluster_name      = "$(AKS_CLUSTER_NAME)"
aks_node_count        = 3
aks_vm_size           = "Standard_DS2_v2"
```

### Step 5: Deploy the infrastructure
Run Terraform to create and configure your AKS deployment:

Display the terraform configuration prior to building:
```
terraform plan -var-file="terraform.tfvars" -var "ssh_public_key=$(cat ~/.ssh/id_rsa.pub)"
```

Apply the Terraform configuration:
```bash
terraform apply -var-file="terraform.tfvars" -var "ssh_public_key=$(cat ~/.ssh/id_rsa.pub)"
```

Follow the prompts to confirm the creation of resources. Terraform will create an Azure Kubernetes Service (AKS) cluster with Linux virtual machines.

## Output

After you run this Terraform module, there will be two outputs: `admin_username` and `vm_fqdn`. These two pieces are what you need to ssh into your jumpbox VM once it is generated per Step #6

### Step 6: Access the AKS cluster
Once the deployment is complete, you can access your AKS cluster using the jumpbox VM's public IP address:

```bash
az vm show --resource-group <RESOURCE_GROUP_NAME> --name jumpbox-vm --query publicIpAddress -o tsv
```

Use SSH or RDP to connect to the jumpbox VM and then use `kubectl` to interact with your AKS cluster.

## Post-deployment
After deploying the AKS cluster, you may want to perform additional tasks such as:

* Configuring node pools
* Deploying Kubernetes applications using Helm
* Setting up monitoring and logging for your AKS cluster

Refer to the [official Azure documentation](https://docs.microsoft.com/en-us/azure/aks/) for more information on managing and operating your AKS deployment.

## Contributing
Contributions are welcome! If you find any issues or have suggestions for improvement, please create an issue or submit a pull request.


```
terraform plan -var "name_prefix=linux" -var "hostname=linux$(echo $RANDOM)" -var "ssh_public_key=$(cat ~/.ssh/id_rsa.pub)"
```

> :bulb: As you can see here, there are three required variables (and only three): 
* `name_prefix` (what to prefix your Azure resources with)
* `hostname` (this will be the public DNS name, recommended to randomize it to prevent likeliness of collisions)
* `ssh_public_key` (your public key). To see optional variables and their defaults, take a look at `vars.tf`
