# required variables
variable "gcp_region" {
  type        = string
  description = "GCP Region"
  default     = "us-west1"
}

variable "gcp_zones" {
  type = list(string)
  description = "The zones to host the cluster in"
}

variable "vm_size" {
  type = string
  description = "Google Compute Instance type"
  default = "e2-medium"
}

# GCP service account key file
# description: Path to the GCP service account key file
variable "gcp_credentials" {
  type = string
  description = "Location of service account for GCP"
}

#GCP Project ID
variable "gcp_project_id" {
  type = string
  description = "GCP Project id"
}

variable "gke_cluster_name" {
  type = string
  description = "GKE Cluster Name"
}

variable "gke_network" {
  type = string
  description = "GKE Network Name"
}

variable "gke_subnetwork" {
  type = string
  description = "GKE Subnetwork Name"
}

variable "gke_default_nodepool_name" {
  type = string
  description = "GKE Default NodePool Name"
}

variable "machine_type" {
  type        = string
  description = "Type of the node compute engines."
}

variable "min_count" {
  type        = number
  description = "Minimum number of nodes in the NodePool. Must be >=0 and <= max_node_count."
}

variable "max_count" {
  type        = number
  description = "Maximum number of nodes in the NodePool. Must be >= min_node_count."
}

variable "disk_size_gb" {
  type        = number
  description = "Size of the node's disk."
}

variable "service_account" {
  type        = string
  description = "The service account to run nodes as if not overridden in `node_pools`. The create_service_account variable default value (true) will cause a cluster-specific service account to be created."
}

variable "initial_node_count" {
  type        = number
  description = "The number of nodes to create in this cluster's default node pool."
}