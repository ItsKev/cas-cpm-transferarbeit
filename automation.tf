resource "azurerm_resource_group" "automation" {
  name     = "automation"
  location = "East US"
}

resource "azurerm_automation_account" "sandbox" {
  name                = "test-automation-account"
  location            = azurerm_resource_group.automation.location
  resource_group_name = azurerm_resource_group.automation.name
  sku_name            = "Basic"

  identity {
    type = "SystemAssigned"
  }
}
