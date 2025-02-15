resource "azurerm_automation_runbook" "shutdown_vms" {
  name                    = "shutdown-vms-${azurerm_resource_group.sandbox.name}"
  location                = azurerm_resource_group.sandbox.location
  resource_group_name     = var.automation_account.resource_group_name
  automation_account_name = var.automation_account.name
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
  name                    = "daily-runbook-schedule-${azurerm_resource_group.sandbox.name}"
  resource_group_name     = var.automation_account.resource_group_name
  automation_account_name = var.automation_account.name
  frequency               = "Day"
  interval                = 1
}

resource "azurerm_automation_job_schedule" "daily_runbook" {
  automation_account_name = var.automation_account.name
  resource_group_name     = var.automation_account.resource_group_name
  runbook_name            = azurerm_automation_runbook.shutdown_vms.name
  schedule_name           = azurerm_automation_schedule.daily.name
}
