locals {
  all_policies = [
    { name = "allowed-regions", id = azurerm_policy_definition.allowed_regions.id },
    { name = "allowed-vm-sizes", id = azurerm_policy_definition.allowed_vm_sizes.id },
    { name = "enforce-storage-encryption", id = azurerm_policy_definition.storage_encryption.id },
    { name = "require-mfa", id = azurerm_policy_definition.require_mfa.id },
  ]
}

data "azurerm_subscription" "current" {}

module "sandbox-1" {
  source              = "./modules/sandbox"
  resource_group_name = "sandbox-1"
  policy_assignments  = local.all_policies
  subscription_id     = data.azurerm_subscription.current.id
}

module "sandbox-2" {
  source              = "./modules/sandbox"
  resource_group_name = "sandbox-2"
  policy_assignments  = local.all_policies
  subscription_id     = data.azurerm_subscription.current.id
}
