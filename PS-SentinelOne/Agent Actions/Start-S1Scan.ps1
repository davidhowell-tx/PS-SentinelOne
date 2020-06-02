function Start-S1Scan {
    <#
    .SYNOPSIS
        Initiates a scan on a SentinelOne agent
    
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

    $URI = "/web/api/v2.1/agents/actions/initiate-scan"
    $Method = "POST"
    $Body = @{ filter = @{}}
    $Body.filter.Add("ids", ($AgentID -join ","))

    $Response = Invoke-S1Query -URI $URI -Method $Method -Body ($Body | ConvertTo-Json) -ContentType "application/json"

    if ($Response.data.affected) {
        Write-Output "Scan initiated for $($Response.data.affected) agents"
        return
    }
    Write-Output $Response.data
}