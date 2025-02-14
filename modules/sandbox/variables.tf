variable "subscription_id" {
  description = "The subscription ID in which to create the resources."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the resources."
  type        = string
}

variable "policy_assignments" {
  description = "List of policy definitions to assign"
  type = list(object({
    name = string
    id   = string
  }))
}
