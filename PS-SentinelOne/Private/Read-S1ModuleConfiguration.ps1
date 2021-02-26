function Read-S1ModuleConfiguration {
    <#
    .SYNOPSIS
        Reads the configuration object that has been persisted to disk
    
    .PARAMETER Path
        The file path where the configuration object has been saved
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$True)]
        [String]
        $Path
    )
    Write-Log -Message "Checking for configuration file at $Path" -Level Verbose
	if (-not (Test-Path -Path $Path)) {
        Write-Log -Message "$Path not found."
        return
    }

    Write-Log -Message "Importing configuration settings." -Level Verbose
    $Configuration = Get-Content -Path $Path

    Try {
        return ($Configuration | ConvertFrom-Json)
    } Catch {
        Write-Log -Message "Unable to deserialize saved configuration from json. Please use Remove-S1ModuleConfiguration to remove the saved configuration."
    }
}