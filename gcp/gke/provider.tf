################################
## GCP Provider Module - Main ##
################################

# GCP Provider
#terraform {
#  required_providers {
#    google = {
#      source  = "hashicorp/google"
#      version = "~> 4.0"  # Adjust the version as needed
#    }
#  }
#}

data "google_client_config" "default" {}
provider "kubernetes" {
  host                   = "https://${module.gke.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke.ca_certificate)
}

provider "google" {
  credentials = file(var.gcp_credentials)
  project     = var.gcp_project_id
  region      = var.gcp_region
}
