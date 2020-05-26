function Remove-S1ModuleConfiguration {
    <#
    .SYNOPSIS
        Remove persisted configuration for PS-SentinelOne module
    
    .PARAMETER All
        Delete the configuration file from disk
    
    .PARAMETER Name
        Only remove a specific field from the persisted configuration
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$False)]
        [Switch]
        $All,

        [Parameter(Mandatory=$True,ParameterSetName="Value")]
        [ValidateSet("URI","ApiToken","TemporaryToken")]
        [String[]]
        $Value
    )
    # Log the command executed by the user
    $InitializationLog = $MyInvocation.MyCommand.Name
    $MyInvocation.BoundParameters.GetEnumerator() | ForEach-Object { $InitializationLog = $InitializationLog + " -$($_.Key) $($_.Value)"}
    Write-Log -Message $InitializationLog -Level Verbose

    if ($All) {
        if (Test-Path -Path $Script:PSSentinelOne.ConfPath) {
            Write-Log -Message "Remove all was specified. Deleting the configuration file from $($Script:PSSentinelOne.ConfPath)" -Level Verbose
            Remove-Item -Path $Script:PSSentinelOne.ConfPath -Force
        } else {
            Write-Log -Message "Unable to locate configuration file to be deleted." -Level Warning
        }
        return
    }

    Write-Log -Message "Retrieving the saved configuration" -Level Verbose
    $Configuration = Get-S1ModuleConfiguration -Persisted

    if ($Value -contains "URI") {
        Write-Log -Message "Removing URI from saved configuration" -Level Verbose
        $Configuration.PSObject.Properties.Remove("URI")
    }
    if ($Value -contains "ApiToken") {
        Write-Log -Message "Removing API Token from saved configuration" -Level Verbose
        $Configuration.PSObject.Properties.Remove("ApiToken")
    }
    if ($Value -contains "TemporaryToken") {
        Write-Log -Message "Removing Temporary Token from saved configuration" -Level Verbose
        $Configuration.PSObject.Properties.Remove("TemporaryToken")
    }

    Try {
        Write-Log -Message "Saving configuration to $($Script:PSSentinelOne.ConfPath)" -Level Verbose
        Save-S1ModuleConfiguration -Path $Script:PSSentinelOne.ConfPath -InputObject $Configuration
    } Catch {
        Write-Log -Message "Error received when attempting to save configuration to $($Script:PSSentinelOne.ConfPath)" -Level Error
    }
}