function Start-S1Reload {
    <#
    .SYNOPSIS
        Initiates service reload on a SentinelOne agent
    
    .PARAMETER AgentID
        Agent ID for the agent you want to scan
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$True)]
        [String[]]
        $AgentID,

        [Parameter(Mandatory=$True)]
        [ValidateSet("log", "static", "agent", "monitor")]
        [String]
        $Module
    )
    # Log the function and parameters being executed
    $InitializationLog = $MyInvocation.MyCommand.Name
    $MyInvocation.BoundParameters.GetEnumerator() | ForEach-Object { $InitializationLog = $InitializationLog + " -$($_.Key) $($_.Value)"}
    Write-Log -Message $InitializationLog -Level Informational

    $URI = "/web/api/v2.1/private/agents/support-actions/reload"
    $Method = "POST"
    $Body = @{ data = @{}; filter = @{}}
    $Body.filter.Add("ids", ($AgentID -join ","))
    $Body.data.Add("module", $Module.ToLower())

    $Response = Invoke-S1Query -URI $URI -Method $Method -Body ($Body | ConvertTo-Json) -ContentType "application/json"

    if ($Response.data.affected) {
        Write-Output "Service reload initiated for $($Response.data.affected) agents"
        return
    }
    Write-Output $Response.data
}