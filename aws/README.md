# Terraform AWS Amazon Linux EC2 Instance

Deploying an Amazon Linux EC2 Instance in AWS using Terraform

## Requirements

- Terraform
- AWS Account/Subscription

## Setup and Configuration

Ensure that you have Terraform installed. If not, you may [reference the official Terraform documentation on installing](https://developer.hashicorp.com/terraform/install)

```
which terraform
```

You may define the following environment variables:

- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`

`AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` are authentication credentials used to grant access to your AWS (Amazon Web Services) account and its associated resources.

**AWS_ACCESS_KEY_ID**

* **Purpose**: The `AWS_ACCESS_KEY_ID` is a unique identifier that represents your AWS account. It's used to authenticate your requests to AWS services.
* **Location**: You can find your `AWS_ACCESS_KEY_ID` in the AWS Management Console or by creating an access key using the following steps:
	+ Sign in to the AWS Management Console (<https://aws.amazon.com/console/>).
	+ Navigate to the "Security, Identity & Compliance" section and click on "IAM".
	+ Click on "Users", then select your user name.
	+ Click on the "Credentials" tab.
	+ Look for the "Access key" field; if it's blank, click on "Create access key". The `AWS_ACCESS_KEY_ID` will be displayed in the dialog that appears.

**AWS_SECRET_ACCESS_KEY**

* **Purpose**: The `AWS_SECRET_ACCESS_KEY` is a secret code used to verify your identity when making requests to AWS services. It should be kept confidential and secure.
* **Location**: You can find your `AWS_SECRET_ACCESS_KEY` by following these steps:
	+ Sign in to the AWS Management Console (<https://aws.amazon.com/console/>).
	+ Navigate to the "Security, Identity & Compliance" section and click on "IAM".
	+ Click on "Users", then select your user name.
	+ Click on the "Credentials" tab.
	+ Look for the "Secret access key" field; if it's blank, click on "Create access key". The `AWS_SECRET_ACCESS_KEY` will be displayed in the dialog that appears.

**Note:** It's recommended to create a new access key and update your applications and scripts with the new credentials. This helps ensure security and prevents unauthorized access to your AWS account.

Also, remember that it's crucial to keep both `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` secure and confidential, as they grant access to your AWS account and its associated resources. Never share these credentials publicly or store them in unprotected locations.


## Provisioning

### Run module directly

Clone this repository to a local or virtual directory
```
$ mkdir /home/$(USERNAME)/projects/dev
$ cd /home/$(USERNAME)/projects/dev
$ git clone https://github.com/xfactor20/compute-services.git
$ cd /home/$(USERNAME)/projects/dev/compute-services/aws/ec2
```

```
terraform init
```

```
terraform plan
```

For now, you will be prompted for aws_access_key and aws_secret_key.  These two parameters are your AWS account's aws access id and secret key for access AWS API either by aws CLI or terraform.

If you are satisfied, then start the provisioning process...

```
terraform apply
```

## Output
After you run the terraform apply, there will be four outputs: `vm_linux_server_instance_id`, `vm_linux_server_instance_public_dns`, `vm_linux_server_instance_public_ip`, `vm_linux_server_instance_private_ip`. You can identify the EC2 instance with the id on AWS console.  The FQDN DNS hostname is given next.  The public IP is static IP that is elastic so IP will persist even when instance is stopped.

You are able to SSH to the morpheus lumerin EC2 instance or host with the generated SSH public/private key pair file by terraform in the current directory:

```
chmod 400 ./morpheus_lumerin-linux-<aws-region>.pem
ssh -i morpheus_lumerin-linux-<aws-region>.pem ec2-user@<public_ip>
```

Please do not forget to destroy the services with:

```
terraform destroy
```

The public static IP is additional extra cost  every hour if it is not attached to the instance so be careful.
Please ensure to detach it and release it on AWS console just to make sure.

# Terraform AWS EKS

Deploying an Amazon Kubernetes EKS cluster on AWS using Terraform

## Requirements

- Terraform
- AWS Account/Subscription

## Setup and Configuration

Ensure that you have Terraform installed. If not, you may [reference the official Terraform documentation on installing](https://developer.hashicorp.com/terraform/install)

```
which terraform
```

You may define the following environment variables:

- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`

`AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` are authentication credentials used to grant access to your AWS (Amazon Web Services) account and its associated resources.

**AWS_ACCESS_KEY_ID**

* **Purpose**: The `AWS_ACCESS_KEY_ID` is a unique identifier that represents your AWS account. It's used to authenticate your requests to AWS services.
* **Location**: You can find your `AWS_ACCESS_KEY_ID` in the AWS Management Console or by creating an access key using the following steps:
	+ Sign in to the AWS Management Console (<https://aws.amazon.com/console/>).
	+ Navigate to the "Security, Identity & Compliance" section and click on "IAM".
	+ Click on "Users", then select your user name.
	+ Click on the "Credentials" tab.
	+ Look for the "Access key" field; if it's blank, click on "Create access key". The `AWS_ACCESS_KEY_ID` will be displayed in the dialog that appears.

**AWS_SECRET_ACCESS_KEY**

* **Purpose**: The `AWS_SECRET_ACCESS_KEY` is a secret code used to verify your identity when making requests to AWS services. It should be kept confidential and secure.
* **Location**: You can find your `AWS_SECRET_ACCESS_KEY` by following these steps:
	+ Sign in to the AWS Management Console (<https://aws.amazon.com/console/>).
	+ Navigate to the "Security, Identity & Compliance" section and click on "IAM".
	+ Click on "Users", then select your user name.
	+ Click on the "Credentials" tab.
	+ Look for the "Secret access key" field; if it's blank, click on "Create access key". The `AWS_SECRET_ACCESS_KEY` will be displayed in the dialog that appears.

**Note:** It's recommended to create a new access key and update your applications and scripts with the new credentials. This helps ensure security and prevents unauthorized access to your AWS account.

Also, remember that it's crucial to keep both `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` secure and confidential, as they grant access to your AWS account and its associated resources. Never share these credentials publicly or store them in unprotected locations.

## Provisioning

### Run module directly

Clone this repository to a local or virtual directory
```
$ mkdir /home/$(USERNAME)/projects/dev
$ cd /home/$(USERNAME)/projects/dev
$ git clone https://github.com/xfactor20/compute-services.git
$ cd /home/$(USERNAME)/projects/dev/compute-services/aws/eks
```

Initialize Terraform
```
terraform init
```

Review the provisioning plan
```
terraform plan
```

The aws_access_key and aws_secret_key are sourced from the env variables in vars.auto.tfvars file.  These two parameters are your AWS account's aws access id and secret key for access AWS API either by aws CLI or terraform.

If verification passes, start the provisioning process

```
terraform apply
```

## Output
Please login to your aws console and find the new EKS cluster created named **morpheus_lumerin_eks_cluster**.

In order to use kubectl from your local development machine accessing the cluster please do the following:
```
aws eks update-kubeconfig \
--region us-west-1 \
--name morpheus_lumerin_eks_cluster
```

Reminder to destroy the cluster and other services created after:
```
terraform destroy
```

**IMPORTANT**: There is also a public static IP that that is extra cost and fees for every hour if it is not attached to the instance so be careful.
Please ensure to detach it and release it onto AWS console to be certain.  It should also be destroyed by terraform.


