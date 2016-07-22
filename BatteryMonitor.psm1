. (Join-Path $PSScriptRoot .\Get-BatteryChargingStatus.ps1)
. (Join-Path $PSScriptRoot .\Get-BatteryStatus.ps1)
. (Join-Path $PSScriptRoot .\Start-BatteryMonitoring.ps1)


Export-ModuleMember -Function Get-BatteryStatus
Export-ModuleMember -Function Start-BatteryMonitoring