This document is an attempt to map the SentinelOne API Documentation to the related PS-SentinelOne command syntax

This documentation is still in progress.

<details>
<summary>Accounts</summary>

### Create Account
Not Planned / Supported.
Requires Global or Support permissions

### Expire an Account
Not Planned / Supported.
Requires Global or Support permissions

### Generate/Regenerate Uninstall Password
Not Planned / Supported.
Requires a ticket with Support to enable.

### Get Account by ID

```PowerShell
Get-S1Account -AccountID <id>
```

### Get Accounts

```PowerShell
Get-S1Account -Name <string> -AccountID <string[]> -Count <int> -SortBy {accountType | activeAgents | createdAt | expiration | id | name | numberOfSites | state | updatedAt} -SortOrder {asc | desc} -CountOnly
```

### Get Uninstall Password
Not Planned / Supported.
Seems to require Global or Support Permissions. Documentation doesn't specify.

### Get Uninstall Password Metadata
Not Planned / Supported.
Seems to require Global or Support Permissions. Documentation doesn't specify.

### Reactivate Account
Not Planned / Supported.
Requires Global or Support permissions

### Revert Policy
Not Planned / Supported.

### Revoke Uninstall Password
Not Planned / Supported.

### Update Account
Not Planned / Supported.
Requires Global or Support permissions

</details>

<details>
<summary>Activities</summary>

### Get Activities

```PowerShell
Get-S1Activity
```

### Get Activity Types

```PowerShell
Get-S1ActivityType
```

### Last activity as Syslog message
Not currently supported. May be added in the future.

</details>

<details>
<summary>Agent Actions</summary>

### Abort Scan

```PowerShell
Invoke-S1AgentAction -AgentID <String[]> -AbortScan
```

### Approve Uninstall

```PowerShell
Invoke-S1AgentAction -AgentID <String[]> -ApproveUninstall
```

### Broadcast Message
```PowerShell
Invoke-S1AgentAction -AgentID <String[]> -SendMessage <String>
```

### Can run Remote Shell

```PowerShell
Invoke-S1AgentAction -AgentID <String[]> -CanRunRemoteShell
```

### Connect to Network

```PowerShell
Invoke-S1AgentAction -AgentID <String[]> -ConnectToNetwork
```

### Decommission

```PowerShell
Invoke-S1AgentAction -AgentID <String[]> -Decommission
```

### Disable Agent

```PowerShell
Invoke-S1AgentAction -AgentID <String[]> -DisableAgent
```

### Disable Ranger

```PowerShell
Invoke-S1AgentAction -AgentID <String[]> -DisableRanger
```

### Disconnect from Network

```PowerShell
Invoke-S1AgentAction -AgentID <String[]> -DisconnectFromNetwork
```

### Enable Agent

```PowerShell
Invoke-S1AgentAction -AgentID <String[]> -EnableAgent
```

### Enable Ranger

```PowerShell
Invoke-S1AgentAction -AgentID <String[]> -EnableRanger
```

### Fetch Files

```PowerShell
Invoke-S1FetchFile -AgentID <String> -FilePath <String[]> -Password <String>
```

```PowerShell
Invoke-S1FetchFile -Agent <agent_id> -FilePath "/path/to/file", "C:\path\to\file" -Password "SuperSecretPassword"
```

### Fetch Firewall Logs

```PowerShell
Invoke-S1AgentAction -Agent <agent_id> -FetchFirewallLogs -ReportLocal <boolean> -ReportManagement <boolean>
```

### Fetch Firewall Rules
Documentation currently only mentions the "native" format and "initial" states

```PowerShell
Invoke-S1AgentAction -Agent <agent_id> -FetchFirewallRules -FirewallRuleFormat "native" -FirewallRuleState "initial"
```

### Fetch Logs

```PowerShell
Invoke-S1AgentAction -Agent <agent_id> -FetchLogs -PlatformLogs $true -AgentLogs $true -CustomerFacingLogs $true
```

### Get Applications

```PowerShell
Invoke-S1AgentAction -Agent <agent_id> -GetApplications
```

### Initiate Scan

```PowerShell
Invoke-S1AgentAction -Agent <agent_id> -Scan
```

### Mark as up-to-date

```PowerShell
Invoke-S1AgentAction -Agent <agent_id> -MarkAsUpToDate
```

### Move between Sites

```PowerShell
Invoke-S1AgentAction -Agent <agent_id> -MoveToSite -SiteID <site_id>
```

### Move to Console

```PowerShell
Invoke-S1AgentAction -Agent <agent_id> -MoveToConsole -ConsoleSiteToken <console_site_token>
```

### Randomize UUID

```PowerShell
Invoke-S1AgentAction -Agent <agent_id> -RandomizeUUID
```

### Reject Uninstall

```PowerShell
Invoke-S1AgentAction -Agent <agent_id> -RejectUninstall
```

### Reset Local Config

```PowerShell
Invoke-S1AgentAction -Agent <agent_id> -ResetLocalConfig
```

### Restart

```PowerShell
Invoke-S1AgentAction -Agent <agent_id> -Restart
```

### Set External ID

```PowerShell
Invoke-S1AgentAction -Agent <agent_id> -SetExternalID <external_id>
```

### Set Persistent Configuration Overrides
Not Planned / Supported.
Requires Global or Support permissions

### Shutdown

```PowerShell
Invoke-S1AgentAction -Agent <agent_id> -Shutdown
```

### Start Remote Profiling

```PowerShell
Invoke-S1AgentAction -Agent <agent_id> -StartRemoteProfiling -TimeoutInSeconds 60
```

### Start Remote Shell
Not yet implemented

### Stop Remote Profiling

```PowerShell
Invoke-S1AgentAction -Agent <agent_id> -StopRemoteProfiling
```

### Terminate Remote Shell
Not yet implemented

### Uninstall

```PowerShell
Invoke-S1AgentAction -Agent <agent_id> -Uninstall
```

### Update Software

```PowerShell
Invoke-S1AgentAction -AgentID $Agent.id -UpdateSoftware -PackageID $Package.id -UpdateTiming immediately
```

</details>

<details>
<summary>Agent Support Actions</summary>

### Clear Remote Shell
Not yet implemented

</details>

<details>
<summary>Agents</summary>

### Applications

```PowerShell
Get-S1Application -AgentID <agent_id>
```

### Count Agents
Not yet implemented

### Export Agent Logs
Not yet implemented

### Export Agents
Not yet implemented

### Get Agents

```PowerShell
Get-S1Agent -Name <String> -ScanStatus <String[]> -MachineType <String[]> -OSType <String[]> -MitigationMode <String> -Infected <String> -AppVulnerabilityStatus <String[]> -IsPendingUninstall <String> -IsUninstalled <String> -IsDecommissioned <String> -ADQuery <String[]> -Domain <String[]> -LocalIP <String[]> -AgentID <String[]> -GroupID <String[]> -SiteID <String[]> -AccountID <String[]>
```

### Get Passphrase

```PowerShell
Get-S1Passphrase
```

### Processes
Not implemented. Labeled as obsolete

</details>

<details>
<summary>Application Inventory</summary>

### Counters
Not implemented. Labeled as deprecated.

### Grouped App inventory
Not implemented. Labeled as deprecated.

</details>

<details>
<summary>Application Risk</summary>

### Export Applications
Not implemented

### Get Applications

```PowerShell
Get-S1Application -ApplicationName <String[]> -ApplicationID <String[]> -GroupID <String[]> -SiteID <String[]> -AccountID <String[]> -RiskLevel <String[]> -ApplicationType <String[]> -OS <String[]> -MachineType <String[]> -Decommissioned <String>
```

### Get CVEs
Not implemented

</details>

<details>
<summary>Config Overrides</summary>

</details>

<details>
<summary>Custom Detection Rule</summary>

</details>

<details>
<summary>Deep Visibility</summary>

</details>

<details>
<summary>Device Control</summary>

</details>

<details>
<summary>Exclusions and Blacklist</summary>

</details>

<details>
<summary>Filters</summary>

</details>

<details>
<summary>Firewall Control</summary>

</details>

<details>
<summary>Forensics</summary>

</details>

<details>
<summary>Gateways</summary>

</details>

<details>
<summary>Groups</summary>

</details>

<details>
<summary>Hashes</summary>

</details>

<details>
<summary>Locations</summary>

</details>

<details>
<summary>Network Quarantine Control</summary>

</details>

<details>
<summary>Policies</summary>

</details>

<details>
<summary>RBAC</summary>

</details>

<details>
<summary>Ranger</summary>

</details>

<details>
<summary>Reports</summary>

</details>

<details>
<summary>Rogues</summary>

</details>

<details>
<summary>Settings</summary>

</details>

<details>
<summary>Sites</summary>

</details>

<details>
<summary>System</summary>

### Cache Status

```PowerShell
Get-S1System -CacheStatus
```

### Database Status

```PowerShell
Get-S1System -DatabaseStatus
```

### Get System Config
Not implemented

### Set System Config
Not implemented

### System Info

```PowerShell
Get-S1System -Info
```

### System Status

```PowerShell
Get-S1System -Status
```

</details>

<details>
<summary>Tags</summary>

</details>

<details>
<summary>Threat Notes</summary>

</details>

<details>
<summary>Threats</summary>

</details>

<details>
<summary>Updates</summary>

### Delete Packages
Not currently supported.

### Deploy System Package
Not currently supported.

### Download Agent Package
Not currently supported. Labeled as Deprecated.

### Download Package

### Get Latest Packages
Available options:
```PowerShell
Get-S1Package -OSType <String[]> -Status <String[]> -PackageType <String> -FileExtension <String> -Query <String> -Version <String> -PackageID <String[]> -AccountID <String[]> -SiteID <String[]>
```

Specific example:
```PowerShell
Get-S1Package -Status ga -OSType windows -FileExtension .exe -Version "4.6.12.241" -Query "64bit"
```

### Latest Packages by OS
Not currently supported. Labeled as Deprecated.

### Update package
Not currently supported.

### Upload Agent Package
Not currently supported.

### Upload System Package
Not currently supported.

</details>

<details>
<summary>Users</summary>

</details>

<details>
<summary>Alerts</summary>

</details>

<details>
<summary>Tasks_Configurations</summary>

</details>