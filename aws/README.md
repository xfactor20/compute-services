# Terraform AWS Amazon Linux EC2 Instance

Deploying an Amazon Linux EC2 Instance in AWS using Terraform

## Requirements

- Terraform
- AWS Account/Subscription

## Setup and Configuration

Ensure that you have Terraform installed. If you don't, you can [reference the official Terraform documentation on installing](https://www.terraform.io/intro/getting-started/install.html)...

```
which terraform
```

You may define the following environment variables:

- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`

## Provisioning

### Run module directly

Clone this repository...
```
$ git clone https://github.com/indrgun/terraform-azure-linux-vm
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

Please do not forget to destroy the services with:

```
terraform destroy
```

The public static IP is additional extra cost  every hour if it is not attached to the instance so be careful.
Please ensure to detach it and release it on AWS console just to make sure.




