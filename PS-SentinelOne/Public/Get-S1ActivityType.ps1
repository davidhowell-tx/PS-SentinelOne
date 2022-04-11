function Get-S1ActivityType {
    <#
    .SYNOPSIS
        Get a list of activity types
    #>
    [CmdletBinding()]
    Param()
    Process {
        # Log the function and parameters being executed
        $InitializationLog = $MyInvocation.MyCommand.Name
        $MyInvocation.BoundParameters.GetEnumerator() | ForEach-Object { $InitializationLog = $InitializationLog + " -$($_.Key) $($_.Value)"}
        Write-Log -Message $InitializationLog -Level Verbose
        
        $URI = "/web/api/v2.1/activities/types"
        $Response = Invoke-S1Query -URI $URI -Method GET -Recurse
        Write-Output $Response.data
    }
}