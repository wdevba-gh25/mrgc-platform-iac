# Rename this file to backend.tf after you create the Terraform state storage resources
# and replace the placeholder values.

terraform {
  backend "azurerm" {
    resource_group_name  = "rg-tfstate-emergency-surge"
    storage_account_name = "sttfemergencysurge"
    container_name       = "tfstate"
    key                  = "dev.terraform.tfstate"
  }
}
