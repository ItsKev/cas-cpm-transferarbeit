resource "azurerm_resource_group" "sandbox" {
  name     = var.resource_group_name
  location = "East US"
}

resource "azurerm_resource_group_policy_assignment" "policies" {
  for_each = { for policy in var.policy_assignments : policy.name => policy }

  name                 = "${each.value.name}-assignment-${azurerm_resource_group.sandbox.name}"
  resource_group_id    = azurerm_resource_group.sandbox.id
  policy_definition_id = each.value.id
}
