provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "sandbox_rg" {
  name     = "Sandbox-1"
  location = "East US"
}

resource "azurerm_virtual_network" "sandbox_vnet" {
  name                = "SandboxVNet"
  resource_group_name = azurerm_resource_group.sandbox_rg.name
  location            = azurerm_resource_group.sandbox_rg.location
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "sandbox_subnet" {
  name                 = "SandboxSubnet"
  resource_group_name  = azurerm_resource_group.sandbox_rg.name
  virtual_network_name = azurerm_virtual_network.sandbox_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}
