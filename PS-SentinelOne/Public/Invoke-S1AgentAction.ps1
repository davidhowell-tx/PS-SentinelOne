function Invoke-S1AgentAction {
    <#
    .SYNOPSIS
        Initiate various actions against SentinelOne agents
    #>
    [CmdletBinding()]
    Param(
        # ID for the Agent(s) being targeted for an action
        [Parameter(Mandatory=$True)]
        [ValidateNotNullorEmpty()]
        [String[]]
        $AgentID,

        # Initiates a scan on the targeted agents
        [Parameter(Mandatory=$True,ParameterSetName="Scan")]
        [Switch]
        $Scan,

        # Aborts a running scan for the targeted agents
        [Parameter(Mandatory=$True,ParameterSetName="AbortScan")]
        [Switch]
        $AbortScan,

        # Initiates service reload for the targeted agents
        [Parameter(Mandatory=$True,ParameterSetName="Reload")]
        [ValidateSet("log", "static", "agent", "monitor")]
        [String]
        $Reload,

        # Starts the remote profiler (for troubleshooting) for the targeted agents
        [Parameter(Mandatory=$True,ParameterSetName="StartRemoteProfiling")]
        [Switch]
        $StartRemoteProfiling,

        # Sets the remote profiler timeout
        [Parameter(Mandatory=$True,ParameterSetName="StartRemoteProfiling")]
        [uint32]
        $TimeoutInSeconds,

        # Stops the remote profiler for the targeted agents
        [Parameter(Mandatory=$True,ParameterSetName="StopRemoteProfiling")]
        [Switch]
        $StopRemoteProfiling,

        # Initiate an agent update for the targeted agents
        [Parameter(Mandatory=$True,ParameterSetName="UpdateSoftware")]
        [Switch]
        $UpdateSoftware,

        # The Package ID for the update to be applied
        [Parameter(Mandatory=$True,ParameterSetName="UpdateSoftware")]
        [ValidateNotNullorEmpty()]
        [String]
        $PackageID,

        # The timing for the update, either immediate or follow the configured update schedule
        [Parameter(Mandatory=$True,ParameterSetName="UpdateSoftware")]
        [ValidateSet("immediately", "by_update_schedule")]
        [String]
        $UpdateTiming,

        # Randomize the UUID for the targeted agents
        [Parameter(Mandatory=$True,ParameterSetName="RandomizeUUID")]
        [Switch]
        $RandomizeUUID,

        # Sends a message to the targeted agents
        [Parameter(Mandatory=$True,ParameterSetName="SendMessage")]
        [ValidateNotNullorEmpty()]
        [String]
        $SendMessage,

        # Update the External ID for the targeted agents
        [Parameter(Mandatory=$True,ParameterSetName="SetExternalID")]
        [String]
        $SetExternalID,

        # Move agents
        [Parameter(Mandatory=$True,ParameterSetName="MoveToGroup")]
        [Parameter(Mandatory=$True,ParameterSetName="MoveToSite")]
        [Switch]
        $Move,

        # The group ID to which the targeted agents should be moved
        [Parameter(Mandatory=$True,ParameterSetName="MoveToGroup")]
        [String]
        $GroupID,

        # The site ID to which the targeted agents should be moved
        [Parameter(Mandatory=$True,ParameterSetName="MoveToSite")]
        [String]
        $SiteID,
        
        # Move agents to a new console
        [Parameter(Mandatory=$True,ParameterSetName="MoveToConsole")]
        [Switch]
        $MoveToConsole,

        # The site token for the console to which the targeted agents should be moved
        [Parameter(Mandatory=$True,ParameterSetName="MoveToConsole")]
        [String]
        $ConsoleSiteToken,

        # Fetch logs from the targeted agents
        [Parameter(Mandatory=$True,ParameterSetName="FetchLogs")]
        [Switch]
        $FetchLogs,

        # Fetch platform logs
        [Parameter(Mandatory=$False,ParameterSetName="FetchLogs")]
        [Boolean]
        $PlatformLogs = $True,

        # Fetch agent logs
        [Parameter(Mandatory=$False,ParameterSetName="FetchLogs")]
        [Boolean]
        $AgentLogs = $True,

        # Fetch customer facing logs
        [Parameter(Mandatory=$False,ParameterSetName="FetchLogs")]
        [Boolean]
        $CustomerFacingLogs = $True,

        # Disable the agent software
        [Parameter(Mandatory=$True,ParameterSetName="DisableAgent")]
        [Switch]
        $DisableAgent,

        # Re-enable the agent software
        [Parameter(Mandatory=$True,ParameterSetName="EnableAgent")]
        [Switch]
        $EnableAgent,

        # Disconnect the targeted agents from the network (network quarantine)
        [Parameter(Mandatory=$True,ParameterSetName="DisconnectFromNetwork")]
        [Switch]
        $DisconnectFromNetwork,

        # Connect the targeted agents back to the network (network unquarantine)
        [Parameter(Mandatory=$True,ParameterSetName="ConnectToNetwork")]
        [Switch]
        $ConnectToNetwork,

        # Fetch firewall logs from the targeted agents
        [Parameter(Mandatory=$True,ParameterSetName="FetchFirewallLogs")]
        [Switch]
        $FetchFirewallLogs,

        [Parameter(Mandatory=$True,ParameterSetName="FetchFirewallLogs")]
        [Boolean]
        $ReportLocal,

        [Parameter(Mandatory=$True,ParameterSetName="FetchFirewallLogs")]
        [Boolean]
        $ReportManagement,

        [Parameter(Mandatory=$True,ParameterSetName="FetchFirewallRules")]
        [Switch]
        $FetchFirewallRules,

        [Parameter(Mandatory=$False,ParameterSetName="FetchFirewallRules")]
        [ValidateSet("initial")]
        [String]
        $FirewallRuleState = "initial",

        [Parameter(Mandatory=$False,ParameterSetName="FetchFirewallRules")]
        [ValidateSet("native")]
        [String]
        $FirewallRuleFormat = "native",

        [Parameter(Mandatory=$True,ParameterSetName="ResetLocalConfig")]
        [Switch]
        $ResetLocalConfig,

        # Approve uninstallation of the agent software
        [Parameter(Mandatory=$True,ParameterSetName="ApproveUninstall")]
        [Switch]
        $ApproveUninstall,

        # Reject uninstallation of the agent software
        [Parameter(Mandatory=$True,ParameterSetName="RejectUninstall")]
        [Switch]
        $RejectUninstall,

        # Initiate a remote uninstall of the agent software
        [Parameter(Mandatory=$True,ParameterSetName="Uninstall")]
        [Switch]
        $Uninstall,

        # Decommission the targeted agents
        [Parameter(Mandatory=$True,ParameterSetName="Decommission")]
        [Switch]
        $Decommission,

        [Parameter(Mandatory=$True,ParameterSetName="DisableRanger")]
        [Switch]
        $DisableRanger,

        [Parameter(Mandatory=$True,ParameterSetName="EnableRanger")]
        [Switch]
        $EnableRanger,

        # Check if a remote shell can be opened to the targeted agents
        [Parameter(Mandatory=$True,ParameterSetName="CanRunRemoteShell")]
        [Switch]
        $CanRunRemoteShell,

        # Request the agent to update the application list for the targeted agents
        [Parameter(Mandatory=$True,ParameterSetName="GetApplications")]
        [Switch]
        $GetApplications,

        [Parameter(Mandatory=$True,ParameterSetName="MarkAsUpToDate")]
        [Switch]
        $MarkAsUpToDate,

        # Initiate a remote restart
        [Parameter(Mandatory=$True,ParameterSetName="Restart")]
        [Switch]
        $Restart,

        # Initiate a remote shutdown
        [Parameter(Mandatory=$True,ParameterSetName="Shutdown")]
        [Switch]
        $Shutdown
    )
    # Log the function and parameters being executed
    $InitializationLog = $MyInvocation.MyCommand.Name
    $MyInvocation.BoundParameters.GetEnumerator() | ForEach-Object { $InitializationLog = $InitializationLog + " -$($_.Key) $($_.Value)"}
    Write-Log -Message $InitializationLog -Level Informational

    $Method = "POST"
    $Body = @{ data = @{}; filter = @{}}
    $Body.filter.Add("ids", ($AgentID -join ","))

    switch ($PSCmdlet.ParameterSetName) {
        "Scan" {
            $URI = "/web/api/v2.1/agents/actions/initiate-scan"
            $OutputMessage = "Scan initiated for"
        }
        "AbortScan" {
            $URI = "/web/api/v2.1/agents/actions/abort-scan"
            $OutputMessage = "Scan aborted for"
        }
        "Reload" {
            $URI = "/web/api/v2.1/private/agents/support-actions/reload"
            $Body.data.Add("module", $Reload.ToLower())
            $OutputMessage = "Service reload initiated for"
        }
        "StartRemoteProfiling" {
            $URI = "/web/api/v2.1/agents/actions/start-profiling"
            $Body.data.Add("timeout", $TimeoutInSeconds)
            $OutputMessage = "Start Remote Profiling initiated for"
        }
        "StopRemoteProfiling" {
            $URI = "/web/api/v2.1/agents/actions/stop-profiling"
            $OutputMessage = "Stop Remote Profiling initiated for"
        }
        "UpdateSoftware" {
            $URI = "/web/api/v2.1/agents/actions/update-software"
            $Body.data.Add("packageId", $PackageID)
            switch ($UpdateTiming) {
                "immediately" { $Body.data.Add("isScheduled", $False) }
                "by_update_schedule" { $Body.data.Add("isScheduled", $True) }
            }
            $OutputMessage = "Software Update initiated for"
        }
        "RandomizeUUID" {
            $URI = "/web/api/v2.1/agents/actions/randomize-uuid"
            $OutputMessage = "Randomize UUID initiated for"
        }
        "SendMessage" {
            $URI = "/web/api/v2.1/agents/actions/broadcast"
            $Body.data.Add("message", $SendMessage)
            $OutputMessage = "Message sent to"
        }
        "SetExternalID" {
            $URI = "web/api/v2.1/agents/actions/set-external-id"
            $Body.data.Add("externalID", $SetExternalID)
            $OutputMessage = "External ID set for "
        }
        "MoveToGroup" {
            $URI = "/web/api/v2.1/groups/$GroupID/move-agents"
            $Method = "Put"
            $Body.filter.Remove("ids")
            $Body.filter.Add("agentIds", ($AgentID -join ","))
            $OutputMessage = "Move to group $GroupID initiated for"
        }
        "MoveToSite" {
            $URI = "/web/api/v2.1/agents/actions/move-to-site"
            $Body.data.Add("targetSiteId", $SiteID)
            $OutputMessage = "Move to site $SiteID initiated for"
        }
        "MoveToConsole" {
            $URI = "/web/api/v2.1/agents/actions/move-to-console"
            $Body.data.Add("token", $ConsoleSiteToken)
            $OutputMessage = "Move to console $ConsoleSiteToken initiated for"
        }
        "FetchLogs" {
            $URI = "/web/api/v2.1/agents/actions/fetch-logs"
            $Body.data.Add("platformLogs", $PlatformLogs)
            $Body.data.Add("agentLogs", $AgentLogs)
            $Body.data.Add("customerFacingLogs", $CustomerFacingLogs)
            $OutputMessage = "Fetch logs initiated for"
        }
        "FetchFirewallLogs" {
            $URI = "/web/api/v2.1/agents/actions/firewall-logging"
            $Body.data.Add("reportLog", $ReportLocal)
            $Body.data.Add("reportMgmt", $ReportManagement)
            $OutputMessage = "Fetch firewall logs initiated for"
        }
        "FetchFirewallRules" {
            $URI = "/web/api/v2.1/agents/actions/fetch-firewall-rules"
            $Body.data.Add("format", $FirewallRuleFormat)
            $Body.data.Add("state", $FirewallRuleState)
            $OutputMessage = "Fetch firewall rules initiated for"
        }
        "DisconnectFromNetwork" {
            $URI = "/web/api/v2.1/agents/actions/disconnect"
            $OutputMessage = "Network Disconnect initiated for"
        }
        "ConnectToNetwork" {
            $URI = "/web/api/v2.1/agents/actions/connect"
            $OutputMessage = "Network Connect initiated for"
        }
        "ResetLocalConfig" {
            $URI = "/web/api/v2.1/agents/actions/reset-local-config"
            $OutputMessage = "Reset local config command sent to"
        }
        "ApproveUninstall" {
            $URI = "/web/api/v2.1/agents/actions/approve-uninstall"
            $OutputMessage = "Uninstall approved for"
        }
        "RejectUninstall" {
            $URI = "/web/api/v2.1/agents/actions/reject-uninstall"
            $OutputMessage = "Uninstall rejected for"
        }
        "Uninstall" {
            $URI = "/web/api/v2.1/agents/actions/uninstall"
            $OutputMessage = "Uninstall initiated for"
        }
        "Decommission" {
            $URI = "/web/api/v2.1/agents/actions/decommission"
            $OutputMessage = "Decommission initiated for"
        }
        "DisableAgent" {
            $URI = "/web/api/v2.1/agents/actions/disable-agent"
            $OutputMessage = "Disable Agent initiated for"
        }
        "EnableAgent" {
            $URI = "/web/api/v2.1/agents/actions/enable-agent"
            $OutputMessage = "Enable Agent initiated for"
        }
        "DisableRanger" {
            $URI = "/web/api/v2.1/agents/actions/ranger-disable"
            $OutputMessage = "Disable Ranger initiated for"
        }
        "EnableRanger" {
            $URI = "/web/api/v2.1/agents/actions/ranger-enable"
            $OutputMessage = "Enable Ranger initiated for"
        }
        "CanRunRemoteShell" {
            $URI = "/web/api/v2.1/agents/actions/can-start-remote-shell"
            $OutputMessage = "Can Run Remote Shell initiated for"
        }
        "GetApplications" {
            $URI = "/web/api/v2.1/agents/actions/fetch-installed-apps"
            $OutputMessage = "Get Applications initiated for"
        }
        "MarkAsUpToDate" {
            $URI = "/web/api/v2.1/agents/actions/mark-up-to-date"
            $OutputMessage = "Mark as up-to-date initiated for"
        }
        "Restart" {
            $URI = "/web/api/v2.1/agents/actions/restart-machine"
            $OutputMessage = "Restart initiated for"
        }
        "Shutdown" {
            $URI = "/web/api/v2.1/agents/actions/shutdown"
            $OutputMessage = "Shutdown initiated for"
        }
    }

    $Response = Invoke-S1Query -URI $URI -Method $Method -Body ($Body | ConvertTo-Json) -ContentType "application/json"

    if ($Response.data.affected) {
        Write-Output "$OutputMessage $($Response.data.affected) agents"
        return
    }
    Write-Output $Response.data
}