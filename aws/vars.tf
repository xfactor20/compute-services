# required variables
variable "aws_access_key" {
  type = string
  description = "AWS access key"
}

variable "aws_secret_key" {
  type = string
  description = "AWS secret key"
}

variable "aws_region" {
  type = string
  description = "AWS region"
  default     = "us-west-1"
}

# AWS AZ
variable "aws_az" {
  type        = string
  description = "AWS AZ"
  default     = "us-west-1a"
}

variable "app_name" {
  description = "appplication name"
  default     = "morpheus_lumerin"
}

variable "vpc_cidr" {
  description = "full address space allowed to the virtual network"
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "the subset of the virtual network for this subnet"
  default     = "10.0.10.0/24"
}

# Linux Virtual Machine
variable "linux_instance_type" {
  type        = string
  description = "EC2 instance type for Linux Server"
  default     = "t2.micro"
}

variable "linux_associate_public_ip_address" {
  type        = bool
  description = "Associate a public IP address to the EC2 instance"
  default     = true
}

variable "linux_root_volume_size" {
  type        = number
  description = "Volume size of root volumen of Linux Server"
  default     = 30
}

variable "linux_root_volume_type" {
  type        = string
  description = "Volume type of root volume of Linux Server. Can be standard, gp3, gp2, io1, sc1 or st1"
  default     = "gp3"
}

