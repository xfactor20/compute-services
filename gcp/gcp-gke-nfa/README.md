# GCP GKE NFA Terraform Configuration

This repository contains a Terraform configuration that automates the deployment of a Google Kubernetes Engine (GKE) cluster and deploys an Nginx server on it. Below is a detailed breakdown of each component.

## Directory Structure

- **`main.tf`**: Core Terraform configuration for creating the GKE cluster, node pools, and related resources.
- **`variables.tf`**: Defines customizable input variables (e.g., project ID, region).
- **`outputs.tf`**: Defines output values like the GKE cluster name and IP address.
- **`terraform.tfvars.example`**: Example variable file. Create a `terraform.tfvars` file and replace `<YOUR_PROJECT_ID>` with your actual Google Cloud project ID.

## GKE Cluster Creation

The Terraform configuration in `main.tf` creates a GKE cluster with the following properties:

- Single node pool with 3 nodes.
- Nodes have 4 vCPUs, 16 GB memory, and 100 GB storage.
- Deployed in the specified region (`us-central1`).
- Network policies enabled.

## Nginx Server Deployment

The configuration also deploys an Nginx server as a sample application:

- Creates a Kubernetes namespace called `default`.
- Deploys an Nginx server using the `nginx:latest` image.
- Exposes the Nginx service via a load balancer with an external IP address.

## Variable Customization

Customize deployment by editing values in `variables.tf`. Key variables include:

- `project_id`: Google Cloud project ID.
- `region`: GKE cluster deployment region (e.g., `us-central1`).
- `node_pool_name`: Name of the node pool.
- `machine_type`: Machine type for nodes (e.g., `n1-standard-4`).
- `nodes_count`: Number of nodes in the node pool.

After customization, use `terraform plan` to preview changes and `terraform apply` to deploy the GKE cluster and Nginx server.
