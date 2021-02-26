function Save-S1ModuleConfiguration {
    <#
    .SYNOPSIS
        Serializes the provided configuration object to disk as a json file
    
    .PARAMETER InputObject
        The configuration object to persist to disk
    
    .PARAMETER Path
        The file path to save the object as
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$True,ValueFromPipeline=$True)]
        [PSCustomObject]
        $InputObject,

        [Parameter(Mandatory=$True)]
        [String]
        $Path
    )
    # Log the command executed by the user
    $InitializationLog = $MyInvocation.MyCommand.Name
    $MyInvocation.BoundParameters.GetEnumerator() | ForEach-Object { $InitializationLog = $InitializationLog + " -$($_.Key) $($_.Value)"}
    Write-Log -Message $InitializationLog -Level Verbose
    
    Try {
        Write-Log -Message "Saving configuration to $Path" -Level Verbose
        $InputObject | ConvertTo-Json | Out-File -FilePath (New-Item $Path -Force)
    } Catch {
        Write-Log -Message "Error received when attempting to save configuration to $Path" -Level Error
    }
}