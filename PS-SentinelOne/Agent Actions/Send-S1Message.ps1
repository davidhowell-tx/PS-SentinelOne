function Send-S1Message {
    <#
    .SYNOPSIS
        Sends a message to SentinelOne agents
    
    .PARAMETER AgentID
        Agent ID for the agent you want to send a message to
    
    .PARAMETER Message
        The message to send
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$True)]
        [String[]]
        $AgentID,

        [Parameter(Mandatory=$True)]
        [String]
        $Message
    )
    # Log the function and parameters being executed
    $InitializationLog = $MyInvocation.MyCommand.Name
    $MyInvocation.BoundParameters.GetEnumerator() | ForEach-Object { $InitializationLog = $InitializationLog + " -$($_.Key) $($_.Value)"}
    Write-Log -Message $InitializationLog -Level Informational

    $URI = "/web/api/v2.1/agents/actions/broadcast"
    $Method = "POST"
    $Body = @{ data = @{}; filter = @{}}
    $Body.filter.Add("ids", ($AgentID -join ","))
    $Body.data.Add("message", $Message)

    $Response = Invoke-S1Query -URI $URI -Method $Method -Body ($Body | ConvertTo-Json) -ContentType "application/json"

    if ($Response.data.affected) {
        Write-Output "Message sent to $($Response.data.affected) agents"
        return
    }
    Write-Output $Response.data
}