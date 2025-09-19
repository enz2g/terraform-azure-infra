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

resource "azurerm_resource_group" "mtc-rg" {
  name     = "mts-resources"
  location = "east us"
  tags = {
    environment = "dev"
  }
}

resource "azurerm_virtual_network" "mtc-vn" {
  name                = "mtc-network"
  resource_group_name = azurerm_resource_group.mtc-rg.name
  location            = azurerm_resource_group.mtc-rg.location
  address_space       = ["10.123.0.0/16"]

  tags = {
    environment = "dev"
  }
}

resource "azurerm_subnet" "mtc-subnet" {
  name                 = "mtc-subnet"
  resource_group_name  = azurerm_resource_group.mtc-rg.name
  virtual_network_name = azurerm_virtual_network.mtc-vn.name
  address_prefixes     = ["10.123.1.0/24"]
}

resource "azurerm_storage_account" "bradstorageacc01" {
  name                     = "bradstorageacc01"
  resource_group_name      = azurerm_resource_group.mtc-rg.name
  location                 = azurerm_resource_group.mtc-rg.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags = {
    environment = "staging"
  }
}

resource "azurerm_storage_container" "tfstate" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.bradstorageacc01.name
  container_access_type = "private"
}


# resource "azurerm_network_security_group" "mtc-sg" {
#   name                = "mtc-sg"
#   location            = azurerm_resource_group.mtc-rg.location
#   resource_group_name = azurerm_resource_group.mtc-rg.name

#   tags = {
#     environment = "dev"
#   }
# }

# resource "azurerm_network_security_rule" "mtc-dev-rule" {
#   name                        = "mtc-dev-rule"
#   priority                    = 100
#   direction                   = "Inbound"
#   access                      = "Allow"
#   protocol                    = "*"
#   source_port_range           = "*"
#   destination_port_range      = "*"
#   source_address_prefix       = "123.253.188.79/32"
#   destination_address_prefix  = "*"
#   resource_group_name         = azurerm_resource_group.mtc-rg.name
#   network_security_group_name = azurerm_network_security_group.mtc-sg.name
# }

# resource "azurerm_subnet_network_security_group_association" "mtc-sga" {
#   subnet_id                 = azurerm_subnet.mtc-subnet.id
#   network_security_group_id = azurerm_network_security_group.mtc-sg.id
# }

# resource "azurerm_public_ip" "mtc-ip" {
#   name                = "mtc-ip"
#   resource_group_name = azurerm_resource_group.mtc-rg.name
#   location            = azurerm_resource_group.mtc-rg.location
#   allocation_method   = "Static"
#   sku                 = "Standard"

#   tags = {
#     environment = "Dev"
#   }
# }

# resource "azurerm_network_interface" "mtc-nic" {
#   name                = "mtc-nic"
#   location            = azurerm_resource_group.mtc-rg.location
#   resource_group_name = azurerm_resource_group.mtc-rg.name

#   ip_configuration {
#     name                          = "internal"
#     subnet_id                     = azurerm_subnet.mtc-subnet.id
#     private_ip_address_allocation = "dynamic"
#     public_ip_address_id          = azurerm_public_ip.mtc-ip.id
#   }

#   tags = {
#     environment = "dev"
#   }
# }

# resource "azurerm_linux_virtual_machine" "mtc-vm" {
#   name                = "mtc-vm"
#   resource_group_name = azurerm_resource_group.mtc-rg.name
#   location            = azurerm_resource_group.mtc-rg.location
#   size                = "Standard_b1s"
#   admin_username      = "adminuser"
#   network_interface_ids = [
#     azurerm_network_interface.mtc-nic.id,
#   ]

#   admin_ssh_key {
#     username   = "adminuser"
#     public_key = file("C:\\Users\\bradl\\.ssh\\id_rsa.pub")
#   }

#   os_disk {
#     caching              = "ReadWrite"
#     storage_account_type = "Standard_LRS"
#   }

#   source_image_reference {
#     publisher = "Canonical"
#     offer     = "UbuntuServer"
#     sku       = "18.04-LTS"
#     version   = "latest"
#   }
# }