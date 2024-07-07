################################
## GCP Provider Module - Main ##
################################

# GCP Provider
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"  # Adjust the version as needed
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 3.0"  # Adjust the version as needed
    }
  }
  required_version = ">= 1.0.0"
}

provider "google" {
  credentials = file("${var.GOOGLE_CREDENTIALS}")
  project     = var.GCP_PROJECT_ID
  region      = var.gcp_region
}
