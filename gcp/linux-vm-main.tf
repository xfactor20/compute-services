###################################
## Virtual Machine Module - Main ##
###################################

# Create External IP for the GCP Compute instance
resource "google_compute_address" "external_ip" {
  name   = "vm-external-ip"
  region = var.gcp_region
}


# Create GCP Compute Instance
resource "google_compute_instance" "linux-server" {
  name         = "${lower(var.app_name)}-linux-server"
  machine_type = var.vm_size
  zone         = var.gcp_zone

  boot_disk {
    initialize_params {
      image = var.gcp_image
    }
  }

  network_interface {
    network    = google_compute_network.vpc_network.name
    subnetwork = google_compute_subnetwork.subnetwork.name

    access_config {
      nat_ip = google_compute_address.external_ip.address
    }
  }

  metadata = {
    ssh-keys = "${var.admin_username}:${tls_private_key.key_pair.public_key_openssh}"
  }

  tags = ["ssh", "${lower(var.app_name)}-linux-server"]

  service_account {
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }
}

resource "google_compute_firewall" "allow_ssh" {
  name    = "allow-ssh"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "allow_icmp" {
  name    = "allow-icmp"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "icmp"
  }

  source_ranges = ["0.0.0.0/0"]
}
