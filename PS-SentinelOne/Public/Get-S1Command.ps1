function Get-S1Command {
    <#
    .SYNOPSIS
        Retrieve Commands from the management console (pending actions)
    #>
    [CmdletBinding()]
    Param(
        [Parameter()]
        [ValidateSet("pending", "sent", "acknowledged", "canceled")]
        [String[]]
        $Status,

        [Parameter()]
        [String[]]
        $AccountID,

        [Parameter()]
        [String[]]
        $SiteID,

        [Parameter()]
        [String[]]
        $GroupID,

        [Parameter()]
        [String[]]
        $AgentID
    )
    Process {
        # Log the function and parameters being executed
        $InitializationLog = $MyInvocation.MyCommand.Name
        $MyInvocation.BoundParameters.GetEnumerator() | ForEach-Object { $InitializationLog = $InitializationLog + " -$($_.Key) $($_.Value)"}
        Write-Log -Message $InitializationLog -Level Informational

        $URI = "/web/api/v2.1/private/commands"
        $Parameters = @{}
        if ($Status) { $Parameters.Add("statuses", ($Status -join ",") ) }
        if ($AccountID) { $Parameters.Add("accountIds", ($AccountID -join ",") ) }
        if ($SiteID) { $Parameters.Add("siteIds", ($SiteID -join ",") ) }
        if ($GroupID) { $Parameters.Add("groupIds", ($GroupID -join ",") ) }
        if ($AgentID) { $Parameters.Add("agentIds", ($AgentID -join ",") ) }

        $Response = Invoke-S1Query -URI $URI -Method GET -Parameters $Parameters -Recurse
        Write-Output $Response.data
    }
}