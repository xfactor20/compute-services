# Linux VM Provisioning and Azure Kubernetes Service (AKS) setup via Terraform

*Quickly create a single Linux VM in Azure, with sane and secure defaults*

## Requirements

- Terraform
- Azure Subscription

## Setup and Configuration

Ensure that you have Terraform installed. If you don't, you can [reference the official Terraform documentation on installing](https://www.terraform.io/intro/getting-started/install.html)...

```
which terraform
```

The Azure provider in Terraform requires the following environment variables defined...

- `ARM_SUBSCRIPTION_ID`
- `ARM_TENANT_ID`
- `ARM_CLIENT_SECRET`
- `ARM_CLIENT_ID`

Follow the [instructions here](https://www.terraform.io/docs/providers/azurerm/index.html#to-create-using-azure-cli-) on how to create application credentials required for the above variables.

## Provisioning

There are two ways to use this to provision...

1. Clone to git repository and run the module directly
1. Create a new Terraform module that sources this remote module

### Source this remote module

This is approach #2 from above. You can create a base module locally to source this module...

```hcl
module "azlinuxvm" {
  source = "github.com/indrgun/terraform-azure-linux-vm"

  name_prefix    = "myprefix"
  hostname       = "myhostname"
  ssh_public_key = "${file("/home/yourlocaluser/.ssh/id_rsa.pub")}"
}
```

Then run `terraform get` to pull this module, and `terraform plan` to see what will happen, and lastly `terraform apply` to kick off the provisioning.

### Run module directly

Clone this repository...
```
$ git clone https://github.com/indrgun/terraform-azure-linux-vm
```

Navigate your terminal to this module's root directory. It's wise to first see what Terraform will do in your subscription...

```
terraform plan -var "name_prefix=linux" -var "hostname=linux$(echo $RANDOM)" -var "ssh_public_key=$(cat ~/.ssh/id_rsa.pub)"
```

If you are satisfied, then start the provisioning process...

```
terraform apply -var "name_prefix=linux" -var "hostname=linux$(echo $RANDOM)" -var "ssh_public_key=$(cat ~/.ssh/id_rsa.pub)"
```

> :bulb: As you can see here, there are three required variables (and only three): 
* `name_prefix` (what to prefix your Azure resources with)
* `hostname` (this will be the public DNS name, recommended to randomize it to prevent likeliness of collisions)
* `ssh_public_key` (your public key). To see optional variables and their defaults, take a look at `vars.tf`

## Output

After you run this Terraform module, there will be two outputs: `admin_username` and `vm_fqdn`. These two pieces are what you need to then immediately ssh into your new Linux machine.

=========================================

# Terraform-Azure-AKS-Linux-VM
Deploy an Azure Kubernetes Service (AKS) cluster with Linux virtual machines using Terraform.

## Requirements
* Terraform v1.0.x
* Azure CLI (`az` command-line tool)
* Azure subscription and a valid account for authentication

## Usage

### Step 1: Clone the repository
Clone this repository to your local machine:

```bash
git clone https://github.com/indrgun/terraform-azure-linux-vm.git
cd terraform-azure-linux-vm
```

### Step 2: Create a new Azure resource group
Create a new Azure resource group for your AKS deployment. Replace `<RESOURCE_GROUP_NAME>` with a unique name:

```bash
az group create --name <RESOURCE_GROUP_NAME> --location <REGION>
```

Replace `<REGION>` with the desired Azure region, such as `eastus`, `westus2`, or `northcentralus`.

### Step 3: Initialize Terraform
Initialize your working directory and fetch the required Azure provider plugins:

```bash
terraform init
```

### Step 4: Configure variables
Create a file named `terraform.tfvars` with the following contents, replacing placeholders with your own values:

```hcl
# Define your Azure subscription information
azure_subscription_id = "<AZURE_SUBSCRIPTION_ID>"
azure_tenant_id       = "<AZURE_TENANT_ID>"
azure_client_id       = "<AZURE_CLIENT_ID>"
azure_client_secret   = "<AZURE_CLIENT_SECRET>"

# Set the desired AKS cluster settings
aks_cluster_name      = "<AKS_CLUSTER_NAME>"
aks_node_count        = 3
aks_vm_size           = "Standard_DS2_v2"
```

### Step 5: Deploy the infrastructure
Run Terraform to create and configure your AKS deployment:

```bash
terraform apply -var-file="terraform.tfvars"
```

Follow the prompts to confirm the creation of resources. Terraform will create an Azure Kubernetes Service (AKS) cluster with Linux virtual machines.

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
