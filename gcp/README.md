# Terraform AWS Amazon Linux EC2 Instance

Deploying GCP Compute VM instance using Terraform

## Requirements

- Terraform
- GCP Account/Subscription
- GCP Credentials : The service account key JSON file contains the credentials necessary for Terraform to authenticate with GCP and manage resources on your behalf.
- GCP PROJECT ID :  The GCP Project ID uniquely identifies your project within Google Cloud Platform.

## Service Account Key JSON:
What is it? The service account key JSON file contains the credentials necessary for Terraform to authenticate with GCP and manage resources on your behalf.
How to Generate:
Go to the Google Cloud Console.
Navigate to IAM & Admin > Service accounts.
Create a new service account or select an existing one.
Under the "Keys" section, create a new key and select JSON format.
This will download a JSON file containing your service account key.

## GCP Project ID:
What is it? The GCP Project ID uniquely identifies your project within Google Cloud Platform.
How to Find:
In the Google Cloud Console, you'll see your project ID at the top of the dashboard.
Alternatively, you can run gcloud projects list in the Cloud Shell or use the gcloud projects describe command with your project ID to retrieve details, including the ID.


## Setup and Configuration

Ensure that you have Terraform installed. If you don't, you can [reference the official Terraform documentation on installing](https://www.terraform.io/intro/getting-started/install.html)...

```
which terraform
```

You define the following environment variables:

- `GOOGLE_CREDENTIALS`
- `GCP_PROJECT_ID`


## Provisioning

### Run module directly

Clone this repository...
```
$ git clone https://github.com/indrgun/terraform-azure-linux-vm
```

Set GOOGLE_CREDENTIALS and GCP_PROJECT_ID environment variables
```
export GOOGLE_CREDENTIALS=/path/to/your/service-account-key.json
export GCP_PROJECT_ID=<your-gcp-project-id>
```

Start provisioning...
```
terraform init
```

```
terraform plan -var GOOGLE_CREDENTIALS=$GOOGLE_CREDENTIALS -var GCP_PROJECT_ID=$GCP_PROJECT_ID
```

For now, you will be prompted for aws_access_key and aws_secret_key.  These two parameters are your AWS account's aws access id and secret key for access AWS API either by aws CLI or terraform.

If you are satisfied, then start the provisioning process...

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

Please do not forget to destroy the services with:

```
terraform destroy -var GOOGLE_CREDENTIALS=$GOOGLE_CREDENTIALS -var GCP_PROJECT_ID=$GCP_PROJECT_ID
```




