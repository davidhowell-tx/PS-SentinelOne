function Get-S1AvailableActions {
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

    ForEach ($Entry in $Response.data) {
        switch ($Entry.name) {
            "fetchLogs" { Add-Member -InputObject $Entry -MemberType NoteProperty -Name Example -Value "Invoke-S1AgentAction -AgentID <agent_id> -FetchLogs" }
            "initiateScan" { Add-Member -InputObject $Entry -MemberType NoteProperty -Name Example -Value "Invoke-S1AgentAction -AgentID <agent_id> -Scan" }
            "abortScan" { Add-Member -InputObject $Entry -MemberType NoteProperty -Name Example -Value "Invoke-S1AgentAction -AgentID <agent_id> -AbortScan" }
            "disconnectFromNetwork" { Add-Member -InputObject $Entry -MemberType NoteProperty -Name Example -Value "Invoke-S1AgentAction -AgentID <agent_id> -DisconnectFromNetwork" }
            "reconnectToNetwork" { Add-Member -InputObject $Entry -MemberType NoteProperty -Name Example -Value "Invoke-S1AgentAction -AgentID <agent_id> -ReconnectToNetwork" }
            # "updateSoftware" 
            "sendMessage" { Add-Member -InputObject $Entry -MemberType NoteProperty -Name Example -Value "Invoke-S1AgentAction -AgentID <agent_id> -SendMessage <message>" }
            # "shutDown" 
            "decommission" { Add-Member -InputObject $Entry -MemberType NoteProperty -Name Example -Value "Invoke-S1AgentAction -AgentID <agent_id> -Decommission" }
            # "reboot"
            "reloadConf" { Add-Member -InputObject $Entry -MemberType NoteProperty -Name Example -Value "Invoke-S1AgentAction -AgentID <agent_id> -Reload <log, static, agent, monitor>" }
            # "uninstall"
            "approveUninstall" { Add-Member -InputObject $Entry -MemberType NoteProperty -Name Example -Value "Invoke-S1AgentAction -AgentID <agent_id> -ApproveUninstall" }
            "rejectUninstall" { Add-Member -InputObject $Entry -MemberType NoteProperty -Name Example -Value "Invoke-S1AgentAction -AgentID <agent_id> -RejectUninstall" }
            "moveToAnotherSite" { Add-Member -InputObject $Entry -MemberType NoteProperty -Name Example -Value "Invoke-S1AgentAction -AgentID <agent_id> -MoveToSite -TargetSiteID <site.id>" }
            # "configureFirewallLogging"
            # "remoteShell"
            # "clearRemoteShellSession"
            # "purgeResearchData"
            # "purgeCrashDumps"
            # "flushEventsQueue"
            "resetLocalConfiguration" { Add-Member -InputObject $Entry -MemberType NoteProperty -Name Example -Value "Invoke-S1AgentAction -AgentID <agent_id> -ResetLocalConfig" }
            # "restartServices"
            # "markAsUpToDate"
            "protect" { Add-Member -InputObject $Entry -MemberType NoteProperty -Name Example -Value "Invoke-S1AgentAction -AgentID <agent_id> -Protect" }
            "unprotect" { Add-Member -InputObject $Entry -MemberType NoteProperty -Name Example -Value "Invoke-S1AgentAction -AgentID <agent_id> -Unprotect" }
            # "revokeToken"
            # purgeDB
            # controlCrashDumps
            # controlResearchData
            # eventsThrottling
            # configuration
            # migrateAgent
            # randomizeUUID
            # fileFetch
            # showApplications
            # showPassphrase
            # searchOnDeepVisibility
            # viewThreats
            # setCustomerIdentifier
            # enableRanger
            # disableRanger
            Default { Add-Member -InputObject $Entry -MemberType NoteProperty -Name Example -Value "" }
        }
    }
    Write-Output $Response.data
}