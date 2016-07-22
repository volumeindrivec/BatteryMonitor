function Get-BatteryChargingStatus { # Not meant to be exported.  Internal to module.
    [CmdletBinding()]
    param()



    Write-Verbose "$(Get-Date) - Getting battery charging status."
    Write-Debug "$(Get-Date) - Entering the Get-BatteryChargingStatus function."

    Add-Type -AssemblyName System.Windows.Forms
    $BatteryChargeStatus = [System.Windows.Forms.SystemInformation]::PowerStatus.BatteryChargeStatus.ToString().Split(',').Trim()
    $Charging = $false
  
    foreach ($var in $BatteryChargeStatus){
        Write-Debug "$(Get-Date) - In foreach loop in Get-BatteryChargingStatus function."
        if ($var -eq 'Charging') { $Charging = $true }
    } # End foreach

    return $Charging

} # End Get-BatteryChargingStatus function
