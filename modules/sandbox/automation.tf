resource "azurerm_automation_account" "sandbox" {
  name                = "automation-account-${azurerm_resource_group.sandbox.name}"
  location            = azurerm_resource_group.sandbox.location
  resource_group_name = azurerm_resource_group.sandbox.name
  sku_name            = "Basic"

  identity {
    type = "SystemAssigned"
  }
}

data "azurerm_role_definition" "vm_contributor" {
  name = "Virtual Machine Contributor"
}

resource "azurerm_role_assignment" "vm_contributor" {
  scope              = azurerm_resource_group.sandbox.id
  role_definition_id = data.azurerm_role_definition.vm_contributor.id
  principal_id       = azurerm_automation_account.sandbox.identity[0].principal_id
}

resource "azurerm_automation_runbook" "shutdown_vms" {
  name                    = "shutdown-vms"
  location                = azurerm_resource_group.sandbox.location
  resource_group_name     = azurerm_resource_group.sandbox.name
  automation_account_name = azurerm_automation_account.sandbox.name
  log_verbose             = true
  log_progress            = true
  description             = "Runbook to shutdown running VMs on weekends."
  runbook_type            = "PowerShell"

  content = <<-EOF
    try {
        "Logging in to Azure..."
        Connect-AzAccount -Identity
    }
    catch {
        Write-Error -Message $_.Exception
        throw $_.Exception
    }
    
    $ResourceGroupName = "${azurerm_resource_group.sandbox.name}"
    
    $day = (Get-Date).DayOfWeek
    if ($day -eq "Saturday" -or $day -eq "Sunday") {
        Write-Output "It's $day, shutting down running VMs in $ResourceGroupName..."
    
        $runningVMs = Get-AzVM -ResourceGroupName $ResourceGroupName | Where-Object { $_.PowerState -eq "VM running" }
        foreach ($vm in $runningVMs) {
           Stop-AzVM -Name $vm.Name -ResourceGroupName $ResourceGroupName -Force
        }
    }
    else {
        Write-Output "Today is $day. No shutdown required."
    }
  EOF
}

resource "azurerm_automation_schedule" "daily" {
  name                    = "daily-runbook-schedule"
  resource_group_name     = azurerm_resource_group.sandbox.name
  automation_account_name = azurerm_automation_account.sandbox.name
  frequency               = "Day"
  interval                = 1
}

resource "azurerm_automation_job_schedule" "daily_runbook" {
  automation_account_name = azurerm_automation_account.sandbox.name
  resource_group_name     = azurerm_resource_group.sandbox.name
  runbook_name            = azurerm_automation_runbook.shutdown_vms.name
  schedule_name           = azurerm_automation_schedule.daily.name
}
