function Invoke-S1AgentAction {
    <#
    .SYNOPSIS
        Used to send various commands to agents, such as initiate scan, fetch logs, uninstall, etc.

    .PARAMETER Action
        The type of action to take
    
    .PARAMETER AgentID
        The Agent ID to send the command to
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$True)]
        [ValidateSet(
            "InitiateScan",
            "AbortScan",
            "FetchLogs",
            "NetworkDisconnect",
            "NetworkReconnect",
            "Uninstall"
        )]
        [String]
        $Action,

        [Parameter(Mandatory=$True)]
        [String[]]
        $AgentID
    )
    Process {
        # Log the function and parameters being executed
        $InitializationLog = $MyInvocation.MyCommand.Name
        $MyInvocation.BoundParameters.GetEnumerator() | ForEach-Object { $InitializationLog = $InitializationLog + " -$($_.Key) $($_.Value)"}
        Write-Log -Message $InitializationLog -Level Informational

        $Method = "Post"
        $Body = @{
            data = @{}
            filter = @{}
        }

        switch ($Action) {
            "InitiateScan" {
                $URI = "/web/api/v2.0/agents/actions/initiate-scan"
            }
            "AbortScan" {
                $URI = "/web/api/v2.0/agents/actions/abort-scan"
            }
            "FetchLogs" {
                $URI = "/web/api/v2.0/agents/actions/fetch-logs"
            }
            "NetworkDisconnect" {
                $URI = "/web/api/v2.0/agents/actions/disconnect"
            }
            "NetworkReconnect" {
                $URI = "/web/api/v2.0/agents/actions/connect"
            }
            "Uninstall" {
                $URI = "/web/api/v2.0/agents/actions/uninstall"
            }
        }
        
        if ($AgentID) { $Body.filter.Add("ids", ($AgentID -join ",") ) }
        
        $BodyJson = $Body | ConvertTo-Json
        $Response = Invoke-S1Query -URI $URI -Method $Method -Body $BodyJson -ContentType "application/json"
        Write-Output $Response.data
    }
}