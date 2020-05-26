function Remove-S1Group {
    <#
    .SYNOPSIS
        Delete the specified group from SentinelOne
    
    .PARAMETER GroupID
        The Group ID for the group to be deleted
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$True)]
        [String]
        $GroupID
    )
    Process {
        # Log the function and parameters being executed
        $InitializationLog = $MyInvocation.MyCommand.Name
        $MyInvocation.BoundParameters.GetEnumerator() | ForEach-Object { $InitializationLog = $InitializationLog + " -$($_.Key) $($_.Value)"}
        Write-Log -Message $InitializationLog -Level Informational
        
        $URI = "/web/api/v2.0/groups/$GroupID"
        $Response = Invoke-S1Query -URI $URI -Method Delete
        Write-Output $Response.data
    }
}