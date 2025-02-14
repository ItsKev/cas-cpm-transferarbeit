resource "azurerm_resource_group" "sandbox" {
  name     = var.resource_group_name
  location = "East US"
}
