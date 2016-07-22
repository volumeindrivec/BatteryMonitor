function Get-BatteryStatus{
    [CmdletBinding()]
    param()
  
    Add-Type -AssemblyName System.Windows.Forms
    $PowerStatus = [System.Windows.Forms.SystemInformation]::PowerStatus
    $Battery = Get-WmiObject -Namespace root\CIMv2 -Class Win32_Battery
  
    if ($PowerStatus.PowerLineStatus -eq 'Offline'){
        Write-Verbose "$(Get-Date) - Executing loop to correct for initial bad estimated time when switching to battery."
        Do {
          Start-Sleep -Seconds 1
          $Battery = Get-WmiObject -Namespace root\CIMv2 -Class Win32_Battery
          $EstimatedRuntime = $Battery.EstimatedRuntime
          $EstimatedRuntimeHours = $EstimatedRuntime / 60
          $EstimatedRuntimeHours = '{0:N2}' -f $EstimatedRuntimeHours
          Write-Verbose "$(Get-Date) - In Get-BatteryStatus Do loop.  `$EstimatedRuntime is $EstimatedRuntime, which is greater than 4320 seconds (3 days)."
        } # End Do block
        While ( ($EstimatedRuntime -gt 4320) -and ($PowerStatus.PowerLineStatus -eq 'Offline') )  #  4320 seconds = 3 days
    } # End If statment

    Write-Verbose "$(Get-Date) - Creating and writing object."
  
    $props = @{'ComputerName' = $Battery.PSComputerName;
        'Charging' = Get-BatteryChargingStatus;
        'PowerOnline' = $PowerStatus.PowerLineStatus;
        'EstimatedPctRemaining' = $Battery.EstimatedChargeRemaining;
        'EstimatedRuntimeHours' = $EstimatedRuntimeHours
    }

    $obj = New-Object -TypeName PSObject -Property $props
    Write-Output $obj

} # End Get-BatteryStatus function