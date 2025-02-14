resource "azurerm_policy_definition" "allowed_regions" {
  name         = "allowed-regions"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Allowed Regions"
  description  = "Allows resource provisioning only in specific regions"

  policy_rule = jsonencode({
    "if" : {
      "not" : {
        "field" : "location",
        "in" : ["East US"]
      }
    },
    "then" : {
      "effect" : "deny"
    }
  })
}

resource "azurerm_policy_definition" "allowed_vm_sizes" {
  name         = "allowed-vm-sizes"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Allowed VM Sizes"
  description  = "Limits provisioning to specific VM types"

  policy_rule = jsonencode({
    "if" : {
      "not" : {
        "field" : "Microsoft.Compute/virtualMachines/sku.name",
        "in" : ["Standard_D2s_v3", "Standard_B2s"]
      }
    },
    "then" : {
      "effect" : "deny"
    }
  })
}

resource "azurerm_policy_definition" "storage_encryption" {
  name         = "enforce-storage-encryption"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Enforce Storage Encryption"
  description  = "Ensures that all storage accounts are encrypted"

  policy_rule = jsonencode({
    "if" : {
      "field" : "Microsoft.Storage/storageAccounts/encryption.keySource",
      "notEquals" : "Microsoft.Storage"
    },
    "then" : {
      "effect" : "deny"
    }
  })
}

resource "azurerm_policy_definition" "require_mfa" {
  name         = "require-mfa"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Enforce MFA for All Users"
  description  = "Ensures that all user role assignments require MFA"

  policy_rule = jsonencode({
    "if" : {
      "field" : "Microsoft.Authorization/roleAssignments/principalType",
      "equals" : "User"
    },
    "then" : {
      "effect" : "deny"
    }
  })
}

