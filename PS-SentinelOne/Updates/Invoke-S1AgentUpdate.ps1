function Invoke-S1AgentUpdate {
    <#
    .SYNOPSIS
        Initiates an update for the SentinelOne agent
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$True)]
        [String[]]
        $AgentID,

        [Parameter(Mandatory=$True)]
        [String]
        $PackageID
    )
    # Log the function and parameters being executed
    $InitializationLog = $MyInvocation.MyCommand.Name
    $MyInvocation.BoundParameters.GetEnumerator() | ForEach-Object { $InitializationLog = $InitializationLog + " -$($_.Key) $($_.Value)"}
    Write-Log -Message $InitializationLog -Level Informational

    $Method = "POST"
    $Body = @{ data = @{}; filter = @{}}
    $URI = "/web/api/v2.1/agents/actions/update-software"
    $Body.filter.Add("ids", ($AgentID -join ","))
    $Body.data.Add("packageId", $PackageID)
    $OutputMessage = "Update initiated for"

    $Response = Invoke-S1Query -URI $URI -Method $Method -Body ($Body | ConvertTo-Json) -ContentType "application/json"

    if ($Response.data.affected) {
        Write-Output "$OutputMessage $($Response.data.affected) agents"
        return
    }
    Write-Output $Response.data
}