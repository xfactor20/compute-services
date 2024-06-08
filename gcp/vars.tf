# required variables
variable "gcp_image" {
  type        = string
  description = "OS image to provision for the google compute instance"
  default     = "projects/ubuntu-os-cloud/global/images/ubuntu-2004-focal-v20240519"
}

variable "gcp_region" {
  type        = string
  description = "GCP Region"
  default     = "us-west1"
}
variable "gcp_zone" {
  type = string
  description = "GCP Zone"
  default     = "us-west1-b"
}

variable "vm_size" {
  type = string
  description = "Google Compute Instance type"
  default = "e2-medium"
}

# GCP service account key file
# description: Path to the GCP service account key file
variable "GOOGLE_CREDENTIALS" {
  type = string
}

#GCP Project ID
variable "GCP_PROJECT_ID" {
  type = string
}

variable "app_name" {
  type = string
  description = "appplication name"
  default     = "morpheus-lumerin"
}

variable "admin_username" {
  description = "administrator user name"
  default     = "vmadmin"
}

variable "public_subnet_cidr" {
  type = string
  description = "the subset of the virtual network for this subnet"
  default     = "10.0.10.0/24"
}

