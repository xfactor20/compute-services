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
variable "aws_az1" {
  type        = string
  description = "AWS AZ"
  default     = "us-west-1a"
}

variable "aws_az2" {
  type        = string
  description = "AWS AZ"
  default     = "us-west-1b"
}

variable "app_name" {
  description = "appplication name"
  default     = "morpheus_lumerin"
}

variable "eks_version" {
  description = "eks cluster version"
}

variable "eks_cluster_name" {
  description = "cluster name"
  default     = "morpheus_lumerin_eks_cluster"
}

variable "vpc_cidr" {
  description = "full address space allowed to the virtual network"
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "the subset of the virtual network for this subnet"
  default     = "10.0.10.0/24"
}

variable "public_zone1_subnet_cidr" {
  description = "the subset of the public zone1 virtual network for this subnet"
  default     = "10.0.64.0/19"
}

variable "public_zone2_subnet_cidr" {
  description = "the subset of the public zone1 virtual network for this subnet"
  default     = "10.0.96.0/19"
}

variable "private_zone1_subnet_cidr" {
  description = "the subset of the private zone1 virtual network for this subnet"
  default     = "10.0.0.0/19"
}

variable "private_zone2_subnet_cidr" {
  description = "the subset of the private zone2 virtual network for this subnet"
  default     = "10.0.32.0/19"
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

