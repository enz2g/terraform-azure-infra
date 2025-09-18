terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.97.0"
    }
  }
}

provider "azurerm" {
  features {}
}


data "azurerm_client_config" "current" {}

data "azurerm_resource_group" "rg" {
  name = "mts-resources"
}

data "azurerm_virtual_network" "mtc-vn" {
  name                = "mtc-network"
  resource_group_name = data.azurerm_resource_group.rg.name
}

data "azurerm_subnet" "mtc-subnet" {
  name                 = "mtc-subnet"
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = data.azurerm_virtual_network.mtc-vn.name
}

resource "azurerm_key_vault" "vault" {
  name                       = var.vault_name
  location                   = data.azurerm_resource_group.rg.location
  resource_group_name        = data.azurerm_resource_group.rg.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = var.keyvault_sku
  soft_delete_retention_days = 7
}

resource "random_string" "admin_password" {
  length  = 13
  lower   = true
  numeric = true
  special = true
  upper   = true
}

resource "azurerm_key_vault_secret" "admin_password" {
  name         = "adminpassword"
  key_vault_id = azurerm_key_vault.vault.id
  value        = random_string.admin_password.result

  depends_on = [
    azurerm_key_vault.vault,
    random_string.admin_password
  ]
}

# (Optional VM resources commented out here)
# Triggering GitHub Actions test 2.0.1

  