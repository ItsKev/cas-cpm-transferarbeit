resource "azurerm_cost_anomaly_alert" "cost_anomaly_alert" {
  name            = "cost-anomaly-alert"
  display_name    = "Alert DisplayName"
  email_subject   = "Cost Anomaly Alert"
  email_addresses = ["alerts@company.ch"]
}
