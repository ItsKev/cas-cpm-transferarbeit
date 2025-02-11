provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "sandbox-1" {
  name     = "Sandbox-1"
  location = "East US"
}
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "sandbox-1" {
  name     = "Sandbox-1"
  location = "East US"
}
