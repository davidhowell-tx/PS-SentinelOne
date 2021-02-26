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
            "fetchLogs" { Add-Member -InputObject $Entry -MemberType NoteProperty -Name Example -Value "Invoke-S1AgentAction -AgentID $AgentID -FetchLogs" }
            "initiateScan" { Add-Member -InputObject $Entry -MemberType NoteProperty -Name Example -Value "Invoke-S1AgentAction -AgentID $AgentID -Scan" }
            "abortScan" { Add-Member -InputObject $Entry -MemberType NoteProperty -Name Example -Value "Invoke-S1AgentAction -AgentID $AgentID -AbortScan" }
            "disconnectFromNetwork" { Add-Member -InputObject $Entry -MemberType NoteProperty -Name Example -Value "Invoke-S1AgentAction -AgentID $AgentID -DisconnectFromNetwork" }
            "reconnectToNetwork" { Add-Member -InputObject $Entry -MemberType NoteProperty -Name Example -Value "Invoke-S1AgentAction -AgentID $AgentID -ReconnectToNetwork" }
            # "updateSoftware" 
            "sendMessage" { Add-Member -InputObject $Entry -MemberType NoteProperty -Name Example -Value "Invoke-S1AgentAction -AgentID $AgentID -SendMessage <message>" }
            # "shutDown" 
            "decommission" { Add-Member -InputObject $Entry -MemberType NoteProperty -Name Example -Value "Invoke-S1AgentAction -AgentID $AgentID -Decommission" }
            # "reboot"
            "reloadConf" { Add-Member -InputObject $Entry -MemberType NoteProperty -Name Example -Value "Invoke-S1AgentAction -AgentID $AgentID -Reload <log, static, agent, monitor>" }
            # "uninstall"
            "approveUninstall" { Add-Member -InputObject $Entry -MemberType NoteProperty -Name Example -Value "Invoke-S1AgentAction -AgentID $AgentID -ApproveUninstall" }
            "rejectUninstall" { Add-Member -InputObject $Entry -MemberType NoteProperty -Name Example -Value "Invoke-S1AgentAction -AgentID $AgentID -RejectUninstall" }
            "moveToAnotherSite" { Add-Member -InputObject $Entry -MemberType NoteProperty -Name Example -Value "Invoke-S1AgentAction -AgentID $AgentID -MoveToSite -TargetSiteID <site.id>" }
            # "configureFirewallLogging"
            # "remoteShell"
            # "clearRemoteShellSession"
            # "purgeResearchData"
            # "purgeCrashDumps"
            # "flushEventsQueue"
            "resetLocalConfiguration" { Add-Member -InputObject $Entry -MemberType NoteProperty -Name Example -Value "Invoke-S1AgentAction -AgentID $AgentID -ResetLocalConfig" }
            # "restartServices"
            # "markAsUpToDate"
            "protect" { Add-Member -InputObject $Entry -MemberType NoteProperty -Name Example -Value "Invoke-S1AgentAction -AgentID $AgentID -Protect" }
            "unprotect" { Add-Member -InputObject $Entry -MemberType NoteProperty -Name Example -Value "Invoke-S1AgentAction -AgentID $AgentID -Unprotect" }
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