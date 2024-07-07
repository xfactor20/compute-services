##########################################
## Network Single AZ Public Only - Main ##
##########################################

resource "google_compute_network" "vpc_network" {
  name                    = "${lower(var.app_name)}-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnetwork" {
  name          = "${lower(var.app_name)}-public-subnet"
  ip_cidr_range = var.public_subnet_cidr
  region        = var.gcp_region
  network       = google_compute_network.vpc_network.name
}

