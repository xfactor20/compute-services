variable "location" {
  description = "region where the resources should exist"
  type        = string
  default     = "westus"
}

variable "cluster_name" {
  type = string
  default = "mln-aks-cluster" 
}

variable "name_prefix" {
  type = string
  default = "mln-aks-rg"
}

variable "name_container_registry" {
  type = string
  default = "mlnacrregistry"
}

variable "node_count" {
  type = number
  description = "The intial quantity of nodes for the node pool."
  default = 1
}
variable "vm_size" {
  description = "size of the vm to create"
  default     = "Standard_D2_v2"
}

variable "aks_service_principal_app_id" {
  type = string
  default = ""
}

variable "aks_service_principal_client_secret" {
  type = string
  default = ""
}

variable dns_prefix {
  type = string
  default = "mlnaks"
}

variable "admin_username" {
  type        = string
  description = "The admin username for the new cluster."
  default     = "mlnadmin"
}

variable "ssh_public_key" {
  default = "~/.ssh/id_rsa.pub"
}


