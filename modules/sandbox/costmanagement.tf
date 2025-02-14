resource "azurerm_consumption_budget_subscription" "sandbox_budget" {
  # Ignore changes to the time_period block
  lifecycle {
    ignore_changes = [
      time_period,
    ]
  }


  name            = "sandbox-budget-${azurerm_resource_group.sandbox.name}"
  subscription_id = var.subscription_id

  amount     = 500
  time_grain = "Monthly"

  time_period {
    start_date = formatdate("YYYY-MM-01'T'00:00:00Z", timestamp())
    end_date   = "2026-01-01T00:00:00Z"
  }

  filter {
    dimension {
      name   = "ResourceGroupName"
      values = [azurerm_resource_group.sandbox.name]
    }
  }

  notification {
    enabled        = true
    operator       = "GreaterThan"
    threshold      = 50
    threshold_type = "Actual"
    contact_emails = ["alerts@company.ch"]
  }

  notification {
    enabled        = true
    operator       = "GreaterThan"
    threshold      = 75
    threshold_type = "Actual"
    contact_emails = ["alerts@company.ch"]
  }

  notification {
    enabled        = true
    operator       = "GreaterThan"
    threshold      = 90
    threshold_type = "Actual"
    contact_emails = ["alerts@company.ch"]
  }

}
