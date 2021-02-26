function Get-S1HashReputation {
    <#
    .SYNOPSIS
        Retrieve the reputation for a hash
    #>
    [CmdletBinding()]
    Param(
        [Parameter()]
        [String]
        $Value
    )
    Process {
        # Log the function and parameters being executed
        $InitializationLog = $MyInvocation.MyCommand.Name
        $MyInvocation.BoundParameters.GetEnumerator() | ForEach-Object { $InitializationLog = $InitializationLog + " -$($_.Key) $($_.Value)"}
        Write-Log -Message $InitializationLog -Level Informational

        $URI = "/web/api/v2.1/hashes/$Value/reputation"

        $Response = Invoke-S1Query -URI $URI -Method GET
        Write-Output $Response.data
    }
}