resource "azurerm_role_assignment" "example" {
  scope                = azurerm_resource_group.sandbox_rg.id
  role_definition_name = "Contributor"
  principal_id         = "user-object-id"
}
