function Get-S1AgentAvailableActions {
    <#
    .SYNOPSIS
        Returns the actions availabe for a particular SentinelOne agent
    
    .PARAMETER AgentID
        Agent ID for the agent you want to scan
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$True)]
        [String[]]
        $AgentID
    )
    # Log the function and parameters being executed
    $InitializationLog = $MyInvocation.MyCommand.Name
    $MyInvocation.BoundParameters.GetEnumerator() | ForEach-Object { $InitializationLog = $InitializationLog + " -$($_.Key) $($_.Value)"}
    Write-Log -Message $InitializationLog -Level Informational

    $URI = "/web/api/v2.1/private/agents/available-actions"
    $Parameters = @{}
    $Parameters.Add("ids", ($AgentID -join ","))

    $Response = Invoke-S1Query -URI $URI -Method GET -Parameters $Parameters -ContentType "application/json"

    Write-Output $Response.data
}