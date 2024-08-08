# Terraform GCP Compute Instance

Deploying GCP Compute VM instance using Terraform

## Requirements

- Terraform
- GCP Account/Subscription
- GOOGLE_CREDENTIALS : The service account key JSON file contains the credentials necessary for Terraform to authenticate with GCP and manage resources on your behalf.
- GCP_PROJECT_ID :  The GCP_Project_ID uniquely identifies your project within Google Cloud Platform.

GOOGLE_CREDENTIALS (Service Account Key JSON):
What is it? The service account key JSON file contains the credentials necessary for Terraform to authenticate with GCP and manage resources on your behalf.

* Creating and managing `GOOGLE_CREDENTIALS`:
1. In the Google Cloud Console, go to the navigation menu (https://console.cloud.google.com/navigation/menu?&project).
2. Click on "APIs & Services" > "Credentials".
3. Click on "Create credentials" and select "OAuth client ID".
4. Follow the prompts to create a new OAuth client ID.
5. Choose "Desktop app" as the application type (since you're likely running this locally).
6. Enter a name for your client ID, and then click "Create".
7. You'll receive a JSON file containing your GOOGLE_CREDENTIALS. Store it securely.

Note: If you need to generate a JSON key file instead of downloading the credentials file, follow these steps:
1. In the Google Cloud Console, go to the navigation menu (https://console.cloud.google.com/navigation/menu?&project).
2. Click on "APIs & Services" > "Credentials".
3. Click on "Create credentials" and select "API key".
5. Choose "JSON" as the key type.
6. Enter a name for your API key, and then click "Create".
7. You'll receive a JSON file containing your GOOGLE_CREDENTIALS and client secret. Store it securely.

`GCP Project ID`:
What is it? The GCP Project ID uniquely identifies your project within Google Cloud Platform.

* Finding your GCP_PROJECT_ID:
1. Sign in to the Google Cloud Console (https://console.cloud.google.com/).
2. Click on the project you want to work with from the project dropdown menu at the top of the page.
3. Navigate to the "Settings" tab (looks like a gear icon) and click on it.
4. Scroll down to the "Project information" section, where you'll find your GCP_PROJECT_ID.

   NOTE: Alternatively, you can run gcloud projects list in the Cloud Shell or use the gcloud projects describe command with your project ID to retrieve details, including the ID.


## Setup and Configuration

Ensure that you have Terraform installed. If not, you may [reference the official Terraform documentation on installation](https://developer.hashicorp.com/terraform/install)


```
which terraform
```

### Environment Variables
The following environment variables are required:

- `GOOGLE_CREDENTIALS`
- `GCP_PROJECT_ID`

## Provisioning

### Run module directly

Clone this repository to local or virtual directory
```
mkdir /home/[MYUSERNAME]/projects/dev
cd /d /home/[MYUSERNAME]/projects/dev
git clone https://github.com/xfactor20/compute-services
```

Set GCP_PROJECT_ID, GOOGLE_CREDENTIALS environment variables
```
export GOOGLE_CREDENTIALS=/path/to/your/service-account-key.json
export GCP_PROJECT_ID=<your-gcp-project-id>
```

Start provisioning environment...
```
cd /home/[MYUSERNAME]/projects/dev/compute-services/gcp/vm
terraform init
```

Review the plan prior to operations
```
terraform plan -var GOOGLE_CREDENTIALS=$GOOGLE_CREDENTIALS -var GCP_PROJECT_ID=$GCP_PROJECT_ID
```

Confirm all is satisfactory, then start the provisioning process...
```
terraform apply -var GOOGLE_CREDENTIALS=$GOOGLE_CREDENTIALS -var GCP_PROJECT_ID=$GCP_PROJECT_ID
```

## Output
After you run the terraform apply, there will be two outputs: `vm_linux_server_instance_name`, `vm_linux_server_instance_public_ip`. You can identify the GCP Compute VM instance with its name on GCP console.  The public IP can be used to ssh to the VM instance.

You are able to SSH to the morpheus lumerin GCP VM instance or host with the generated SSH public/private key pair file by terraform in the current directory:

```
chmod 400 ./morpheus-lumerin-linux-<gcp-region>.pem
ssh -i morpheus-lumerin-linux-<gcp-region>.pem <vm-user>@<public_ip>
```

Reminder to destroy the services with:

```
terraform destroy -var GOOGLE_CREDENTIALS=$GOOGLE_CREDENTIALS -var GCP_PROJECT_ID=$GCP_PROJECT_ID
```


# Terraform GCP GKE Cluster
Deploying GCP GKE Cluster using Terraform

## Requirements

- Terraform
- GCP Account/Subscription
- GCP Credentials : The service account key JSON file contains the credentials necessary for Terraform to authenticate with GCP and manage resources on your behalf.
- `GCP_PROJECT_ID` :  The GCP Project ID uniquely identifies your project within Google Cloud Platform.
- `SVC_ACCT_NAME`  :  The Service Account used to manage/own the cluster

`SVC_ACCT_NAME` Service Account Key JSON (:
What is it? The service account key JSON file contains the credentials necessary for Terraform to authenticate with GCP and manage resources on your behalf including building the GCE cluster.
The GCP Credential file is generated later via gcloud instead of via Google Cloud Console for the SVC_ACCT_NAME when it is created first.

To locate your `SVC_ACCT_NAME`, follow these steps:
1. Sign in to the Google Cloud Console (https://console.cloud.google.com/).
2. Click on the project you want to work with from the project dropdown menu at the top of the page.
3. Navigate to the "IAM & Admin" tab (looks like a lock icon) and click on it.
4. In the "Service accounts" section, find the service account associated with your project.
5. Click on the three vertical dots (...) next to the service account name, then select "Edit".
6. The SVC_ACCT_NAME will be displayed in the edit window.

`GCP_Project_ID`:
What is it? The GCP Project ID uniquely identifies your project within Google Cloud Platform.

* To locate your `GCP_PROJECT_ID`:
1. Sign in to the Google Cloud Console (https://console.cloud.google.com/).
2. Click on the project you want to work with from the project dropdown menu at the top of the page.
3. Navigate to the "Settings" tab (looks like a gear icon) and click on it.
4. Scroll down to the "Project information" section, where you'll find your GCP_PROJECT_ID.

## Setup and Configuration

Ensure that you have Terraform installed. If not, you may [reference the official Terraform documentation on installation](https://developer.hashicorp.com/terraform/install)

```
which terraform
```

### Environment Variables

The following environment variables are required:

- `GCP_PROJECT_ID`
- `SVC_ACCT_NAME`

```
export GCP_PROJECT_ID=<your-gcp-project-id>
export SVC_ACCT_NAME=<the-service-account-to-own-gce>
```


## Provisioning

### Run module directly

Clone this repository to local or virtual directory
```
mkdir /home/[MYUSERNAME]/projects/dev
cd /d /home/[MYUSERNAME]/projects/dev
git clone https://github.com/xfactor20/compute-services
```

Enable the Google Cloud APIs we will be using, create the service account, grant roles to the service account, create and download key credential json file used by Terraform to authenticate as the service account against GCP API ...
```
cd /home/[MYUSERNAME]/projects/dev/compute-services/gcp/gke
./enable_gcloud_apis.sh \
&& ./create_service_account.sh \
&& ./grant_roles.sh \
&& ./create_keyfile.sh
```

Substitute <GCP_PROJECT_ID> and <SVC_ACCT_NAME> in the vars.auto.tfvars with the values of their environment variables.

Review the provisioning plan first:

```
terraform init
terraform plan
```

if satisfactory, then start the provisioning process:

```
terraform apply -auto-approve
```


Once done with development and testing, reminder to destroy the gce cluster with the command:

```
terraform destroy
```

