resource "azurerm_policy_definition" "require_tags" {
  name         = "require-tags"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Enforce Tags on Resources"
  description  = "Requires the tag 'Environment' on all resources"

  policy_rule = <<POLICY
  {
    "if": { "field": "[concat('tags[', parameters('tagName'), ']')]
", "exists": "false" },
    "then": { "effect": "deny" }
  }
  POLICY

  parameters = <<PARAMS
  {
    "tagName": { "type": "String", "metadata": { "displayName": "Tag Name", "description": "The name of the required tag" } }
  }
  PARAMS
}

resource "azurerm_policy_assignment" "require_tags_assign" {
  name                 = "require-tags-assignment"
  policy_definition_id = azurerm_policy_definition.require_tags.id
  scope                = azurerm_resource_group.sandbox_rg.id
}

resource "azurerm_policy_definition" "allowed_vm_sizes" {
  name         = "allowed-vm-sizes"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Allowed VM Sizes"
  description  = "Limits provisioning to specific VM types"

  policy_rule = <<POLICY
  {
    "if": { "not": { "field": "Microsoft.Compute/virtualMachines/sku.name", "in": ["Standard_D2s_v3", "Standard_B2s"] } },
    "then": { "effect": "deny" }
  }
  POLICY
}

resource "azurerm_policy_definition" "storage_encryption" {
  name         = "enforce-storage-encryption"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Enforce Storage Encryption"
  description  = "Ensures that all storage accounts are encrypted"

  policy_rule = <<POLICY
  {
    "if": { "field": "Microsoft.Storage/storageAccounts/encryption.keySource", "notEquals": "Microsoft.Storage" },
    "then": { "effect": "deny" }
  }
  POLICY
}

resource "azurerm_policy_definition" "allowed_regions" {
  name         = "allowed-regions"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Allowed Regions"
  description  = "Allows resource provisioning only in specific regions"

  policy_rule = <<POLICY
  {
    "if": { "not": { "field": "location", "in": ["westeurope", "northeurope"] } },
    "then": { "effect": "deny" }
  }
  POLICY
}

resource "azurerm_policy_definition" "require_mfa" {
  name         = "require-mfa"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Enforce MFA for Admins"
  description  = "Ensures that administrators use MFA"

  policy_rule = <<POLICY
  {
    "if": {
      "allOf": [
        { "field": "Microsoft.Authorization/roleAssignments/roleDefinitionId", "equals": "/providers/Microsoft.Authorization/roleDefinitions/bb28d53b-2147-446b-b5ef-23b16dfe59c5" },
        { "field": "Microsoft.Authorization/roleAssignments/principalType", "equals": "User" }
      ]
    },
    "then": { "effect": "audit" }
  }
  POLICY
}
