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
 resource_group_name        = data.azurerm_resource_group.rg.name

  }


data "azurerm_subnet" "mtc-subnet" {
  name                 = "mtc-subnet"
  resource_group_name        = data.azurerm_resource_group.rg.name
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
  name = "adminpassword"
  key_vault_id = azurerm_key_vault.vault.id
  value = random_string.admin_password.result
  depends_on = [ azurerm_key_vault.vault,random_string.admin_password ]
}

# resource "azurerm_network_interface" "Windows_VM" {
#   name                = "win-nic"
#    location                   = data.azurerm_resource_group.rg.location
#   resource_group_name        = data.azurerm_resource_group.rg.name

#   ip_configuration {
#     name                          = "internal"
#     subnet_id                     = data.azurerm_subnet.mtc-subnet.id
#     private_ip_address_allocation = "Dynamic"
#   }
# }

# resource "azurerm_windows_virtual_machine" "Windows_VM" {
#   name                = "WindowsVM"
#   location                   = data.azurerm_resource_group.rg.location
#   resource_group_name        = data.azurerm_resource_group.rg.name
#   size                = "Standard_B1s"
#   admin_username      = "adminuser"
#   admin_password      = azurerm_key_vault_secret.admin_password.value
#   network_interface_ids = [
#     azurerm_network_interface.Windows_VM.id,
#   ]

#   os_disk {
#     caching              = "ReadWrite"
#     storage_account_type = "Standard_LRS"
#   }

#   source_image_reference {
#     publisher = "MicrosoftWindowsServer"
#     offer     = "WindowsServer"
#     sku       = "2016-Datacenter"
#     version   = "latest"
#   }
# }