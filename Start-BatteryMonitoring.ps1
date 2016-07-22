function Start-BatteryMonitoring {
    [cmdletbinding()]
    
    param(
        [Parameter(Mandatory=$True)][pscredential]$Credential,
        [Parameter(Mandatory=$True)][string[]]$To,
        [Parameter(Mandatory=$True)][string]$From,
        [string]$Subject = "Power alert notification from $env:COMPUTERNAME.",
        [string]$SmtpServer,
        [int]$Port = 25,
        [switch]$UseSsl,
        $AlertThreshold = 30,
        $LogFile = 'C:\BatteryMon\BatteryMon-' + (Get-Date -Format yyyyMMdd) + '.log'
    )

    if (-not (Test-Path -Path C:\BatteryMon)) { New-Item -Path C:\BatteryMon -ItemType Directory }
    Out-File -FilePath $LogFile -Append -InputObject ((Get-Date -Format g) + ' - Start-BatteryMonitoring Logging started: ' + $LogFile )
    $LastAlert = (Get-Date).AddHours(-2)
    $HourLog = (Get-Date).AddHours(-1)

    Do {
        Write-Verbose "$(Get-Date) - Checking status."
        # Checks every five seconds.  This is the initial pause.
        Start-Sleep -Seconds 5
        
        $BatteryStatus = Get-BatteryStatus

        if ((-not $BatteryStatus.Charging) -and ($BatteryStatus.PowerOnline -ne 'Online')){
            $PowerRestored = $false
            $PwrStatus = "Power is $($BatteryStatus.PowerOnline)."
            $ChrgStatus = "Battery charging is $($BatteryStatus.Charging)."
            $PctStatus = "Estimated percent remaining is $($BatteryStatus.EstimatedPctRemaining)%."
            $RunStatus = "Estimated runtime is $($BatteryStatus.EstimatedRuntimeHours) hours."

            Write-Verbose "$(Get-Date) - $PwrStatus"
            Write-Verbose "$(Get-Date) - $ChrgStatus"  
            Write-Verbose "$(Get-Date) - $PctStatus"
            Write-Verbose "$(Get-Date) - $RunStatus"

            $Body = $PwrStatus + "`n" + $ChrgStatus + "`n" + $PctStatus + "`n" + $RunStatus + "`n"
          
            if ((Get-Date) -gt $LastAlert.AddMinutes($AlertThreshold) ) {
            
                Write-Verbose "$(Get-Date) - Sending email alert."
          
                Out-File -FilePath $LogFile -Append -InputObject ((Get-Date -Format g) + ' - Sending alert.')
                Out-File -FilePath $LogFile -Append -InputObject ((Get-Date -Format g) + " - $PwrStatus" )
                Out-File -FilePath $LogFile -Append -InputObject ((Get-Date -Format g) + " - $ChrgStatus" )
                Out-File -FilePath $LogFile -Append -InputObject ((Get-Date -Format g) + " - $PctStatus" )
                Out-File -FilePath $LogFile -Append -InputObject ((Get-Date -Format g) + " - $RunStatus" )
          
                Send-MailMessage -To $To -From $From -Subject $Subject -Body $Body -SmtpServer $SmtpServer -Port $Port -UseSsl:$UseSsl -Credential $Credential
                
                $LastAlert = Get-Date
                $NextAlert = (Get-Date).AddMinutes($AlertThreshold)
          
                Write-Verbose "$(Get-Date) - Alert sent. Next alert to be sent at $NextAlert if issue is not corrected."
                Out-File -FilePath $LogFile -Append -InputObject ((Get-Date -Format g) + " - Alert sent.  Next alert to be sent at $NextAlert if issue is not corrected." )
          
            } # End if block
        
        } # End if block
        elseif ((-not $BatteryStatus.Charging) -and ($BatteryStatus.PowerOnline -eq 'Online')){
            Write-Verbose "$(Get-Date) - Power restored, not charging."
            $LastAlert = (Get-Date).AddHours(-2)
            $PwrStatus = "Power is $($BatteryStatus.PowerOnline)."
            $ChrgStatus = "Battery charging is $($BatteryStatus.Charging)."
            $PctStatus = "Estimated percent remaining is $($BatteryStatus.EstimatedPctRemaining)%."
            $RunStatus = "Estimated runtime is $($BatteryStatus.EstimatedRuntimeHours) hours."

            Write-Verbose "$(Get-Date) - $PwrStatus"
            Write-Verbose "$(Get-Date) - $ChrgStatus"  
            Write-Verbose "$(Get-Date) - $PctStatus"
            Write-Verbose "$(Get-Date) - $RunStatus"

            $Body = $PwrStatus + "`n" + $ChrgStatus + "`n" + $PctStatus + "`n" + $RunStatus + "`n"
 
            if (-not $PowerRestored) {
          
                Write-Verbose "$(Get-Date) - Sending power restored email alert."
          
                Out-File -FilePath $LogFile -Append -InputObject ((Get-Date -Format g) + ' - Sending alert.')
                Out-File -FilePath $LogFile -Append -InputObject ((Get-Date -Format g) + " - $PwrStatus" )
                Out-File -FilePath $LogFile -Append -InputObject ((Get-Date -Format g) + " - $ChrgStatus" )
                Out-File -FilePath $LogFile -Append -InputObject ((Get-Date -Format g) + " - $PctStatus" )
                Out-File -FilePath $LogFile -Append -InputObject ((Get-Date -Format g) + " - $RunStatus" )
          
                Send-MailMessage -To $To -From $From -Subject $Subject -Body $Body -SmtpServer $SmtpServer -Port $Port -UseSsl:$UseSsl -Credential $Credential
          
                Write-Verbose "$(Get-Date) - Power restored alert sent."
                Out-File -FilePath $LogFile -Append -InputObject ((Get-Date -Format g) + ' - Power restored alert sent.' )
                $PowerRestored = $True
          
            } # End if block

        } # End ElseIf block
        elseif (($BatteryStatus.Charging) -and ($BatteryStatus.PowerOnline -eq 'Online')){
            Write-Verbose "$(Get-Date) - Power restored, charging."
            $LastAlert = (Get-Date).AddHours(-2)
            $PwrStatus = "Power is $($BatteryStatus.PowerOnline)."
            $ChrgStatus = "Battery charging is $($BatteryStatus.Charging)."
            $PctStatus = "Estimated percent remaining is $($BatteryStatus.EstimatedPctRemaining)%."
            $RunStatus = "Estimated runtime is $($BatteryStatus.EstimatedRuntimeHours) hours."

            Write-Verbose "$(Get-Date) - $PwrStatus"
            Write-Verbose "$(Get-Date) - $ChrgStatus"  
            Write-Verbose "$(Get-Date) - $PctStatus"
            Write-Verbose "$(Get-Date) - $RunStatus"

            $Body = $PwrStatus + "`n" + $ChrgStatus + "`n" + $PctStatus + "`n" + $RunStatus + "`n"
 
            if (-not $PowerRestored) {
          
                Write-Verbose "$(Get-Date) - Sending power restored email alert."
          
                Out-File -FilePath $LogFile -Append -InputObject ((Get-Date -Format g) + ' - Sending alert.')
                Out-File -FilePath $LogFile -Append -InputObject ((Get-Date -Format g) + " - $PwrStatus" )
                Out-File -FilePath $LogFile -Append -InputObject ((Get-Date -Format g) + " - $ChrgStatus" )
                Out-File -FilePath $LogFile -Append -InputObject ((Get-Date -Format g) + " - $PctStatus" )
                Out-File -FilePath $LogFile -Append -InputObject ((Get-Date -Format g) + " - $RunStatus" )
          
                Send-MailMessage -To $To -From $From -Subject $Subject -Body $Body -SmtpServer $SmtpServer -Port $Port -UseSsl:$UseSsl -Credential $Credential
          
                Write-Verbose "$(Get-Date) - Power restored alert sent."
                Out-File -FilePath $LogFile -Append -InputObject ((Get-Date -Format g) + ' - Power restored alert sent.' )
                $PowerRestored = $True
          
            } # End if block
       
        } # End ElseIf block

        if ((Get-Date) -ge $HourLog ) {
            $PwrStatus = "Power is $($BatteryStatus.Charging)."
            Write-Verbose "$(Get-Date) - $PwrStatus"  
            Out-File -FilePath $LogFile -Append -InputObject ((Get-Date -Format g) + " - $PwrStatus" )

            $ChrgStatus = "Battery charging is $($BatteryStatus.Charging)."
            Write-Verbose "$(Get-Date) - $ChrgStatus"
            Out-File -FilePath $LogFile -Append -InputObject ((Get-Date -Format g) + " - $ChrgStatus" )

            $PctStatus = "Estimated percent remaining is $($BatteryStatus.EstimatedPctRemaining)%."
            Write-Verbose "$(Get-Date) - $PctStatus"
            Out-File -FilePath $LogFile -Append -InputObject ((Get-Date -Format g) + " - $PctStatus" )

            if ( $BatteryStatus.EstimatedRuntimeHours ) {
                $RunStatus = "Estimated runtime is $($BatteryStatus.EstimatedRuntimeHours) hours."
                Write-Verbose "$(Get-Date) - $RunStatus"
                Out-File -FilePath $LogFile -Append -InputObject ((Get-Date -Format g) + " - $RunStatus" )
            } # End If block
            $HourLog = (Get-Date).AddHours(1)
        }
        
    } # End Do block
    While ( -not $StartShutdown )

} # End Start-BatteryMonitoring function