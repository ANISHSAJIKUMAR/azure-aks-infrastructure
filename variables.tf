variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "origen-ai-rg"
}

variable "location" {
  description = "Azure region to deploy resources"
  type        = string
  default     = "centralindia"
}

variable "acr_name" {
  description = "Name of the Azure Container Registry"
  type        = string
  default     = "origenairegistry"
}

variable "cluster_name" {
  description = "Name of the AKS cluster"
  type        = string
  default     = "origen-ai-aks"
}

variable "kubernetes_version" {
  description = "Kubernetes version"
  type        = string
  default     = "2024-08-01"
}

variable "node_count" {
  description = "Number of AKS worker nodes"
  type        = number
  default     = 2
}

variable "vm_size" {
  description = "Size of AKS worker nodes"
  type        = string
  default     = "Standard_DS2_v2"
}

variable "frontend_app_name" {
  description = "Name of the frontend app service"
  type        = string
  default     = "origen-ai-frontend"
}
