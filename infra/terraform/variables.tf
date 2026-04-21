variable "subscription_id" {
  type        = string
  description = "Azure Subscription ID"
}

variable "location" {
  type        = string
  description = "Azure region"
  default     = "eastus"
}

variable "platform_resource_group_name" {
  type        = string
  description = "Main resource group for the platform"
  default     = "rg-emergency-surge-platform"
}

variable "acr_name" {
  type        = string
  description = "Azure Container Registry name"
  default     = "acremergencysurge"
}

variable "aks_cluster_name" {
  type        = string
  description = "AKS cluster name"
  default     = "aks-emergency-surge"
}

variable "dns_prefix" {
  type        = string
  description = "AKS DNS prefix"
  default     = "emergency-surge"
}

variable "node_count" {
  type        = number
  description = "System node pool count"
  default     = 1
}

variable "vm_size" {
  type        = string
  description = "AKS VM size"
  default     = "Standard_B4ms"
}

variable "kubernetes_version" {
  type        = string
  description = "Optional AKS Kubernetes version"
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "Common tags"
  default = {
    project     = "emergency-surge-demo"
    environment = "platform"
    managed_by  = "terraform"
  }
}
