function Invoke-S1AgentAction {
    <#
    .SYNOPSIS
        Initiates a scan on a SentinelOne agent
    
    .PARAMETER AgentID
        Agent ID for the agent you want to scan
    
    .PARAMETER Scan
        Initiates a scan on a SentinelOne agent
    
    .PARAMETER AbortScan
        Aborts a running scan on a SentinelOne agent
    
    .PARAMETER Protect
        Sends a protect command to a SentinelOne agent
    
    .PARAMETER Unprotect
        Sends an unprotect command to a SentinelOne agent
    
    .PARAMETER Reload
        Initiates service reload on a SentinelOne agent
    
    .PARAMETER SendMessage
        Sends a message to SentinelOne agents
    
    .PARAMETER FetchLogs
        Sends a fetch log command for a SentinelOne agent
    
    .PARAMETER DisconnectFromNetwork
        Sends a command to disconnect a SentinelOne agent from the network
    
    .PARAMETER ReconnectToNetwork
        Sends a command to reconnect a SentinelOne agent to the network
    
    .PARAMETER ResetLocalConfig
        Sends a command to clear the SentinelCtl changes for targeted agents
    
    .PARAMETER ApproveUninstall
        Approve an uninstall request

    .PARAMETER RejectUninstall
        Reject an uninstall request

    .PARAMETER MoveToSite
        Move an agent to a different site. Use with -TargetSiteID

    .PARAMETER TargetSiteID
        Site ID for the Site where the agent should be moved

    .PARAMETER Decommission
        Decommission an agent
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$True)]
        [String[]]
        $AgentID,

        [Parameter(Mandatory=$True,ParameterSetName="Scan")]
        [Switch]
        $Scan,

        [Parameter(Mandatory=$True,ParameterSetName="AbortScan")]
        [Switch]
        $AbortScan,

        [Parameter(Mandatory=$True,ParameterSetName="Protect")]
        [Switch]
        $Protect,

        [Parameter(Mandatory=$True,ParameterSetName="Unprotect")]
        [Switch]
        $Unprotect,

        [Parameter(Mandatory=$True,ParameterSetName="Reload")]
        [ValidateSet("log", "static", "agent", "monitor")]
        [String]
        $Reload,

        [Parameter(Mandatory=$True,ParameterSetName="StartRemoteProfiling")]
        [Switch]
        $StartRemoteProfiling,

        [Parameter(Mandatory=$True,ParameterSetName="StartRemoteProfiling")]
        [uint32]
        $TimeoutInSeconds,

        [Parameter(Mandatory=$True,ParameterSetName="StopRemoteProfiling")]
        [Switch]
        $StopRemoteProfiling,

        [Parameter(Mandatory=$True,ParameterSetName="RandomizeUUID")]
        [Switch]
        $RandomizeUUID,

        [Parameter(Mandatory=$True,ParameterSetName="SendMessage")]
        [String]
        $SendMessage,

        [Parameter(Mandatory=$True,ParameterSetName="SetExternalID")]
        [String]
        $SetExternalID,

        [Parameter(Mandatory=$True,ParameterSetName="MoveToGroup")]
        [Switch]
        $MoveToGroup,

        [Parameter(Mandatory=$True,ParameterSetName="MoveToGroup")]
        [String]
        $GroupID,

        [Parameter(Mandatory=$True,ParameterSetName="MoveToSite")]
        [Switch]
        $MoveToSite,

        [Parameter(Mandatory=$True,ParameterSetName="MoveToSite")]
        [String]
        $SiteID,
        
        [Parameter(Mandatory=$True,ParameterSetName="MoveToConsole")]
        [Switch]
        $MoveToConsole,

        [Parameter(Mandatory=$True,ParameterSetName="MoveToConsole")]
        [String]
        $ConsoleSiteToken,

        [Parameter(Mandatory=$True,ParameterSetName="FetchLogs")]
        [Switch]
        $FetchLogs,

        [Parameter(Mandatory=$False,ParameterSetName="FetchLogs")]
        [Boolean]
        $PlatformLogs = $True,

        [Parameter(Mandatory=$False,ParameterSetName="FetchLogs")]
        [Boolean]
        $AgentLogs = $True,

        [Parameter(Mandatory=$False,ParameterSetName="FetchLogs")]
        [Boolean]
        $CustomerFacingLogs = $True,

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

        [Parameter(Mandatory=$True,ParameterSetName="DisconnectFromNetwork")]
        [Switch]
        $DisconnectFromNetwork,

        [Parameter(Mandatory=$True,ParameterSetName="ReconnectToNetwork")]
        [Switch]
        $ReconnectToNetwork,

        [Parameter(Mandatory=$True,ParameterSetName="ResetLocalConfig")]
        [Switch]
        $ResetLocalConfig,

        [Parameter(Mandatory=$True,ParameterSetName="ApproveUninstall")]
        [Switch]
        $ApproveUninstall,

        [Parameter(Mandatory=$True,ParameterSetName="RejectUninstall")]
        [Switch]
        $RejectUninstall,

        [Parameter(Mandatory=$True,ParameterSetName="Uninstall")]
        [Switch]
        $Uninstall,

        [Parameter(Mandatory=$True,ParameterSetName="MoveToSite")]
        [String]
        $TargetSiteID,

        [Parameter(Mandatory=$True,ParameterSetName="Decommission")]
        [Switch]
        $Decommission,

        [Parameter(Mandatory=$True,ParameterSetName="DisableAgent")]
        [Switch]
        $DisableAgent,

        [Parameter(Mandatory=$True,ParameterSetName="EnableAgent")]
        [Switch]
        $EnableAgent,

        [Parameter(Mandatory=$True,ParameterSetName="DisableRanger")]
        [Switch]
        $DisableRanger,

        [Parameter(Mandatory=$True,ParameterSetName="EnableRanger")]
        [Switch]
        $EnableRanger,

        [Parameter(Mandatory=$True,ParameterSetName="CanRunRemoteShell")]
        [Switch]
        $CanRunRemoteShell,

        [Parameter(Mandatory=$True,ParameterSetName="GetApplications")]
        [Switch]
        $GetApplications,

        [Parameter(Mandatory=$True,ParameterSetName="MarkAsUpToDate")]
        [Switch]
        $MarkAsUpToDate,

        [Parameter(Mandatory=$True,ParameterSetName="Restart")]
        [Switch]
        $Restart,

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
        "Protect" {
            $URI = "/web/api/v2.1/private/agents/support-actions/protect"
            $OutputMessage = "Protect command initiated for"
        }
        "Unprotect" {
            $URI = "/web/api/v2.1/private/agents/support-actions/unprotect"
            $OutputMessage = "Unprotect command initiated for"
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
            $Body.Add("data", @{"targetSiteId" = $SiteID})
            $OutputMessage = "Move to site $SiteID initiated for"
        }
        "MoveToConsole" {
            $URI = "/web/api/v2.1/agents/actions/move-to-console"
            $Body.Add("data", @{"token" = $ConsoleSiteToken})
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
        "ReconnectToNetwork" {
            $URI = "/web/api/v2.1/agents/actions/connect"
            $OutputMessage = "Network Reconnect initiated for"
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