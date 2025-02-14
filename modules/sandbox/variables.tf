variable "resource_group_name" {
  type = string
}

variable "policy_assignments" {
  description = "List of policy definitions to assign"
  type = list(object({
    name = string
    id   = string
  }))
}
