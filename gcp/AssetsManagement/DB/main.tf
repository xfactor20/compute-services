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
