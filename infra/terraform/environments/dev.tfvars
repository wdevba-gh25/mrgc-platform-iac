subscription_id              = "af989cb4-02c6-4dda-9a94-908e82bb580b"
location                     = "eastus"
platform_resource_group_name = "rg-emergency-surge-platform"
acr_name                     = "acremergencysurge"
aks_cluster_name             = "aks-emergency-surge"
dns_prefix                   = "emergency-surge"
node_count                   = 1
vm_size                      = "Standard_DC2as_v5"

tags = {
  project     = "emergency-surge-demo"
  environment = "dev"
  managed_by  = "terraform"
}
