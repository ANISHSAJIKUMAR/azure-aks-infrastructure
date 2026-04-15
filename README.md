# Azure AKS Infrastructure

Terraform configuration for building an Azure Kubernetes Service environment.

## What it provisions

- Azure resource group
- Azure Container Registry
- AKS cluster
- Public IP resources for frontend and backend load balancers
- Supporting Helm and Kubernetes configuration

## Layout

- `main.tf`: root infrastructure composition
- `providers.tf`: provider configuration
- `variables.tf`: input variables
- `outputs.tf`: exported outputs
- `modules/`: reusable Terraform modules
- `kubernetes/`: Kubernetes manifests
- `helm/`: Helm-related assets

## Run

```bash
terraform init
terraform plan
terraform apply
```
