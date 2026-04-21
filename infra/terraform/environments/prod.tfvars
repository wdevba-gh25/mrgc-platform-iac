location                     = "eastus"
platform_resource_group_name = "rg-emergency-surge-platform"
acr_name                     = "acremergencysurge"
aks_cluster_name             = "aks-emergency-surge"
dns_prefix                   = "emergency-surge"
node_count                   = 1
vm_size                      = "Standard_B4ms"

tags = {
  project     = "emergency-surge-demo"
  environment = "prod"
  managed_by  = "terraform"
}
