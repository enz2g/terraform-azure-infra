terraform {
  backend "azurerm" {
    resource_group_name   = "mts-resources"
    storage_account_name  = "bradstorageacc01"
    container_name        = "tfstate"
    key                   = "terraform.tfstate"
  }
}
