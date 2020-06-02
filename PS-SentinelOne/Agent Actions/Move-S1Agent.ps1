function Move-S1Agent {
    <#
    .SYNOPSIS
        Move SentinelOne agents to a new group or site
    
    .PARAMETER AgentID
        Agent ID for the agent you want to move

    .PARAMETER TargetGroupID
        Group ID for the group where the agent should be moved

    .PARAMETER TargetSiteID
        Site ID for the site where the agent should be moved
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$False)]
        [String[]]
        $AgentID,

        [Parameter(Mandatory=$True,ParameterSetName="MoveToGroup")]
        [ValidateNotNullOrEmpty()]
        [String]
        $TargetGroupID,

        [Parameter(Mandatory=$True,ParameterSetName="MoveToSite")]
        [ValidateNotNullOrEmpty()]
        [String]
        $TargetSiteID
    )
    # Log the function and parameters being executed
    $InitializationLog = $MyInvocation.MyCommand.Name
    $MyInvocation.BoundParameters.GetEnumerator() | ForEach-Object { $InitializationLog = $InitializationLog + " -$($_.Key) $($_.Value)"}
    Write-Log -Message $InitializationLog -Level Informational

    $Body = @{ filter = @{}}
    if ($GroupID) { $Body.filter.Add("groupIds", ($GroupID -join ","))}
    
    if ($PSCmdlet.ParameterSetName -eq "MoveToGroup") {
        $URI = "/web/api/v2.0/groups/$TargetGroupID/move-agents"
        $Method = "Put"
        if ($AgentID) { $Body.filter.Add("agentIds", ($AgentID -join ","))}
    }
    if ($PSCmdlet.ParameterSetName -eq "MoveToSite") {
        $URI = "/web/api/v2.0/agents/actions/move-to-site"
        $Method = "Post"
        $Body.Add("data", @{"targetSiteId" = $TargetSiteID})
        if ($AgentID) { $Body.filter.Add("ids", ($AgentID -join ","))}
    }

    $Response = Invoke-S1Query -URI $URI -Method $Method -Body ($Body | ConvertTo-Json) -ContentType "application/json"

    Write-Output $Response.data
}