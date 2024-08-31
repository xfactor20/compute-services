Here's a `README.md` file formatted in TypeScript for GitHub that provides step-by-step instructions for automating the provisioning and configuration of a GCP VM with a MongoDB container using Terraform.

```markdown
# GCP MongoDB Container Provisioning with Terraform

This project automates the provisioning and configuration of a Google Cloud Platform (GCP) Virtual Machine (VM) to host a MongoDB container using Terraform. The process includes setting up the VM, installing Docker, and deploying MongoDB as a Docker container.

## Prerequisites

Before you begin, ensure you have the following:

- **Google Cloud Platform (GCP) Account**: A GCP project set up.
- **Service Account**: A GCP service account with Compute Admin and Service Account User roles.
- **Google Cloud SDK (gcloud)**: Installed on your local machine. [Install Guide](https://cloud.google.com/sdk/docs/install)
- **Terraform**: Installed on your local machine. [Install Guide](https://www.terraform.io/downloads.html)
- **Service Account Key**: JSON key file for your GCP service account.

## Setup Instructions

### 1. Authenticate and Configure GCP CLI

First, authenticate your GCP account and set the default project:

```bash
gcloud auth login
gcloud config set project <YOUR_GCP_PROJECT_ID>
```

Replace `<YOUR_GCP_PROJECT_ID>` with your actual GCP project ID.

### 2. Enable Required APIs

Ensure the necessary APIs are enabled:

```bash
gcloud services enable compute.googleapis.com
```

### 3. Clone or Create the Terraform Project

Create a directory for your Terraform configuration files and navigate to it:

```bash
mkdir terraform-gcp-mongo
cd terraform-gcp-mongo
```

### 4. Create `main.tf` File

Create a Terraform configuration file named `main.tf` with the following content:

```typescript
provider "google" {
  credentials = file("<PATH_TO_YOUR_SERVICE_ACCOUNT_KEY>.json")
  project     = "<YOUR_GCP_PROJECT_ID>"
  region      = "us-central1"
}

resource "google_compute_instance" "mongodb-vm" {
  name         = "mongodb-vm"
  machine_type = "e2-medium"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }

  network_interface {
    network = "default"

    access_config {
      // Allocate a public IP address
    }
  }

  metadata_startup_script = <<-EOF
    #!/bin/bash
    sudo apt-get update
    sudo apt-get install -y docker.io
    sudo usermod -aG docker $USER
    sudo docker run --name mongodb -d -p 27017:27017 -v /mnt/disks/mongo-data:/data/db mongo
  EOF

  tags = ["http-server", "https-server"]

  service_account {
    email  = google_service_account.default.email
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }
}

resource "google_service_account" "default" {
  account_id   = "terraform-mongodb-sa"
  display_name = "Terraform MongoDB Service Account"
}

output "vm_ip" {
  value = google_compute_instance.mongodb-vm.network_interface[0].access_config[0].nat_ip
}
```

Replace the following placeholders:
- `<PATH_TO_YOUR_SERVICE_ACCOUNT_KEY>.json`: The path to your service account JSON key file.
- `<YOUR_GCP_PROJECT_ID>`: Your GCP project ID.

### 5. Initialize Terraform

Initialize Terraform by running:

```bash
terraform init
```

This command will download the necessary provider plugins.

### 6. Apply the Terraform Configuration

Run the following command to apply the Terraform configuration:

```bash
terraform apply -auto-approve
```

The `-auto-approve` flag bypasses manual approval, automating the process.

### 7. Retrieve the VM IP Address

After Terraform completes, it will output the public IP address of the VM. You can use this IP address to connect to the MongoDB instance running on the VM.

Example output:

```bash
Outputs:

vm_ip = "34.123.45.67"
```

### 8. Connect to MongoDB

Use the following command to connect to MongoDB:

```bash
mongo --host 34.123.45.67 --port 27017
```

Replace `34.123.45.67` with the actual IP address output by Terraform.

## Cleanup

To remove all the resources created by Terraform, run:

```bash
terraform destroy -auto-approve
```

This will delete the VM and all associated resources.

## Notes

- Ensure that your GCP project has the necessary permissions to create and manage resources.
- Modify the `main.tf` file as needed to suit your project requirements.
- Use secure methods to manage and store your service account key file.

## License

This project is licensed under the MIT License. See the LICENSE file for more details.
```

This `README.md` provides a complete guide on setting up a GCP VM with a MongoDB container using Terraform, including how to automate the entire process via the GCP CLI.