# Resource Group
resource "azurerm_resource_group" "this" {
  name     = var.resource_group_name
  location = var.location
}

# Azure Container Registry
module "acr" {
  source              = "./modules/acr"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  acr_name            = var.acr_name
}

# AKS Cluster
module "aks" {
  source              = "./modules/aks"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  cluster_name        = var.cluster_name
  kubernetes_version  = var.kubernetes_version
  node_count          = var.node_count
  vm_size             = var.vm_size
}

# Provision a public IP address for the frontend load balancer
resource "azurerm_public_ip" "frontend_lb_ip" {
  name                = "${var.cluster_name}-public-ip"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = {
    environment = "Production"
  }
}

# Provision a public IP address for the backend load balancer
resource "azurerm_public_ip" "backend_lb_ip" {
  name                = "${var.cluster_name}-backend-public-ip"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = {
    environment = "Production"
  }
}



# Deploy Frontend Using Helm
resource "helm_release" "frontend" {
  name      = "frontend"
  chart     = "./helm/frontend"
  namespace = "default"

  set {
    name  = "replicaCount"
    value = 2
  }

  set {
    name  = "service.type"
    value = "LoadBalancer"
  }

  set {
    name  = "service.port"
    value = "80"
  }

  set {
    name  = "service.loadBalancerIP"
    value = azurerm_public_ip.frontend_lb_ip.ip_address
  }
}

# Deploy Backend Using Helm
resource "helm_release" "backend" {
  name      = "backend"
  chart     = "./helm/backend"
  namespace = "default"

  set {
    name  = "replicaCount"
    value = 2
  }

  set {
    name  = "service.type"
    value = "LoadBalancer"
  }

  set {
    name  = "service.port"
    value = "3001"
  }

  set {
    name  = "service.loadBalancerIP"
    value = azurerm_public_ip.backend_lb_ip.ip_address
  }
}

# Deploy MongoDB Using Helm
resource "helm_release" "mongodb" {
  name      = "mongodb"
  chart     = "./helm/mongodb"
  namespace = "default"

  set {
    name  = "persistence.enabled"
    value = "true"
  }

  set {
    name  = "persistence.size"
    value = "1Gi"
  }

  set {
    name  = "mongodbUsername"
    value = "username"
  }

  set {
    name  = "mongodbPassword"
    value = "password"
  }

  set {
    name  = "mongodbDatabase"
    value = "admin"
  }
}

# Output for the Frontend Load Balancer
output "frontend_ip" {
  value       = azurerm_public_ip.frontend_lb_ip.ip_address
  description = "Public IP address of the frontend load balancer"
}

# Output for the Backend Load Balancer
output "backend_ip" {
  value       = azurerm_public_ip.backend_lb_ip.ip_address
  description = "Public IP address of the backend load balancer"
}

