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
Get-S1Account
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
Invoke-S1AgentAction -AbortScan -Agent <agent_id>
```

### Approve Uninstall

```PowerShell
Invoke-S1AgentAction -ApproveUninstall -Agent <agent_id>
```

### Broadcast Message
```PowerShell
Invoke-S1AgentAction -SendMessage <message> -Agent <agent_id>
```

### Can run Remote Shell

```PowerShell
Invoke-S1AgentAction -CanRunRemoteShell -Agent <agent_id>
```

### Connect to Network

```PowerShell
Invoke-S1AgentAction -ReconnectToNetwork -Agent <agent_id>
```

### Decommission

```PowerShell
Invoke-S1AgentAction -Decommission -Agent <agent_id>
```

### Disable Agent

```PowerShell
Invoke-S1AgentAction -DisableAgent -Agent <agent_id>
```

### Disable Ranger

```PowerShell
Invoke-S1AgentAction -DisableRanger -Agent <agent_id>
```

### Disconnect from Network

```PowerShell
Invoke-S1AgentAction -DisconnectFromNetwork -Agent <agent_id>
```

### Enable Agent

```PowerShell
Invoke-S1AgentAction -EnableAgent -Agent <agent_id>
```

### Enable Ranger

```PowerShell
Invoke-S1AgentAction -EnableRanger -Agent <agent_id>
```

### Fetch Files

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
Not yet implemented

</details>

<details>
<summary>Agent Support Actions</summary>

</details>

<details>
<summary>Agents</summary>

</details>

<details>
<summary>Application Inventory</summary>

</details>

<details>
<summary>Application Risk</summary>

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