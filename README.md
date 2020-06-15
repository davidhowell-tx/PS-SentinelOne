# PS-SentinelOne PowerShell Module


## Table of Contents

* [Overview](#overview)
* [Installation and Removal](#installation-and-removal)
* [Configuration](#configuration)
* [Capability](#capability)

----------
## Overview

This is a PowerShell script module that provides command-line interaction and automation using the SentinelOne REST API.

Development is ongoing, with the goal to add support for the majority of the API set, and an attempt to provide examples for various capabilities.

----------
## Installation and Removal

Installation of this module currently consists of a pair of scripts that will copy the module to one of the PowerShell module paths, and check PowerShell module paths to remove it.

**Install**
```PowerShell
.\Install-Module.ps1
```

**Uninstall**
```PowerShell
.\Uninstall-Module.ps1
```

----------
## Configuration

PS-SentinelOne includes commandlets to configure information specific to your environment, such as the URI of your SentinelOne console, and your API Token.
You may choose to  cache this information for the current session, or save the information to disk. Saved API Tokens are protected by using secure strings.

### In Session Configuration

Commandlets will utilize the URI and API Token cached in the current session.
If no URI or API Token is cached, an attempt will be mode to retrieve any settings that have been saved to disk.

Check the settings in the current session
```PowerShell
PS > Get-S1ModuleConfiguration
```

Set the base URI for your management console, and your API Token for this session
```PowerShell
PS > Set-S1ModuleConfiguration -URI "https://management-tenant.sentinelone.net" -ApiToken "<API Token>"
```

Set the base URI for your management console, and authenticate with your credentials for a temporary token
*Note: You must have a URI set in order to authenticate, otherwise the commandlet will not know where to connect to perform authentication.*
```PowerShell
PS > Set-S1ModuleConfiguration -URI "https://management-tenant.sentinelone.net"
PS > Get-S1Token
Windows PowerShell credential request.
Input SentinelOne username and password to authenticate for a temporary API token.
User: john.smith@acme.com
Password for user john.smith@acme.com: **************
```

### Persisted Configuration

Save to disk the base URI for your management console and your API Token.
```PowerShell
PS > Set-S1ModuleConfiguration -URI "https://management-tenant.sentinelone.net" -ApiToken "<API Token>" -Persist
```

Review any settings saved to disk
```PowerShell
PS > Get-S1ModuleConfiguration -Persisted
```

Manually import saved settings into current session
```PowerShell
PS > Get-S1ModuleConfiguration -Persisted -Cache
```

Saved settings do not need to be manually imported into the current session. This will be done automatically when you attempt to run a commandlet.
You can test this by using the following process:
```PowerShell
PS > Import-Module .\PS-SentinelOne.psm1
PS > Get-S1ModuleConfiguration
Name                           Value
----                           -----
ConfPath                       C:\Users\<username>\AppData\Local\PS-SentinelOne\config.json
PS > Get-S1Site

<OUTPUT REMOVED>

PS > Get-S1ModuleConfiguration

Name                           Value
----                           -----
ManagementURL                  https://management-tenant.sentinelone.net
ApiToken                       <API Token>
ConfPath                       C:\Users\<username>\AppData\Local\PS-SentinelOne\config.json
```

----------
## Capability

**Examples**
* Accounts
  * [Retrieve accounts list](#retrieve-accounts-list)
* Sites
  * [Retrieve sites list](#retrieve-sites-list)
  * [Retrieve sites for account](#retrieve-sites-for-account)
  * [Retrieve active sites](#retrieve-active-sites)
  * [Retrieve a site by name](#retrieve-a-site-by-name)
* Groups
  * [Retrieve all groups in a specific site](#retrieve-all-groups-in-a-specific-site)
  * [Retrieve a specific group in a specific site](#retrieve-a-specific-group-in-a-specific-site)
  * [Create a new group](#create-a-new-group)
  * [Delete a group](#delete-a-group)
* Agents
  * [Retrieve agents in a group](#retrieve-agents-in-a-group)
  * [Retrieve agents with macOS](#retrieve-agents-with-macOS)
  * [Retrieve agents in detect mode](#retrieve-agents-in-detect-mode)
  * [Retrieve infected agents](#retrieve-infected-agents)
  * [Retrieve agents with resolved threats](#retrieve-agents-with-resolved-threats)
* Agent Actions
  * [Get Available Actions](#get-available-actions)
  * [Initiate a scan](#initiate-a-scan)
  * [Abort a scan](#abort-a-scan)

### Retrieve accounts list
```PowerShell
PS > Get-S1Account
```

### Retrieve sites list
```PowerShell
PS > Get-S1Site
```

### Retrieve sites for account
```PowerShell
PS > $Account = Get-S1Account -Name "My Account"
PS > Get-S1Site -AccountID $Account.id
```

### Retrieve active sites
```PowerShell
PS > Get-S1Site -State active # Tab complete capability
```

### Retrieve a site by name
```PowerShell
PS > Get-S1Site -Name "My Site"
```

### Retrieve all groups in a specific site
```PowerShell
PS > $Site = Get-S1Site -Name "My Site"
PS > $Groups = Get-S1Group -SiteID $Site.id
```

### Retrieve a specific group in a specific site
```PowerShell
PS > $Site = Get-S1Site -Name "My Site"
PS > $Groups = Get-S1Group -SiteID $Site.id -Name "Default Group"
```

### Create a new group
```PowerShell
PS > $Site = Get-S1Site -Name "My Site"
PS > $NewGroup = New-S1Group -Name "Test" -SiteID $Site.id
```

### Delete a group
```PowerShell
PS > $Site = Get-S1Site -Name "My Site"
PS > $Group = New-S1Group -Name "Test" -SiteID $Site.id
PS > Remove-S1Group -GroupID $Group.id

success
-------
   True
```

### Retrieve agents in a group
```PowerShell
PS > $Group = Get-S1Group -Name "Default Group"
PS > Get-S1Agent -GroupID $Group.id
```

### Retrieve agents for a certain domain
```PowerShell
PS > Get-S1Agent -Domain acme
```

### Retrieve agents with macOS
```PowerShell
PS > Get-S1Agent -OSType macos
```

### Retrieve agents in detect mode
```PowerShell
PS > Get-S1Agent -MitigationMode detect
```

### Retrieve infected agents
```PowerShell
PS > Get-S1Agent -Infected true
```
### Get Available Actions
```PowerShell
PS > $Agent = Get-S1Agent -Name "Deathstar"
PS > Get-S1AvailableActions -AgentID $Agent.id

isDisabled name                     Example
---------- ----                     -------
     False fetchLogs                Invoke-S1AgentAction -AgentID <agent_id> -FetchLogs
     False initiateScan             Invoke-S1AgentAction -AgentID <agent_id> -Scan
     False abortScan                Invoke-S1AgentAction -AgentID <agent_id> -AbortScan
     False disconnectFromNetwork    Invoke-S1AgentAction -AgentID <agent_id> -DisconnectFromNetwork
     False reconnectToNetwork       Invoke-S1AgentAction -AgentID <agent_id> -ReconnectToNetwork
     False updateSoftware
     False sendMessage              Invoke-S1AgentAction -AgentID <agent_id> -SendMessage <message>
     False shutDown
     False decommission             Invoke-S1AgentAction -AgentID <agent_id> -Decommission
     False reboot
     False reloadConf               Invoke-S1AgentAction -AgentID <agent_id> -Reload <log, static, agent, monitor>
     False uninstall
     False approveUninstall         Invoke-S1AgentAction -AgentID <agent_id> -ApproveUninstall
     False rejectUninstall          Invoke-S1AgentAction -AgentID <agent_id> -RejectUninstall
     False moveToAnotherSite        Invoke-S1AgentAction -AgentID <agent_id> -MoveToSite -TargetSiteID <site.id>
     False configureFirewallLogging
     False remoteShell
     False clearRemoteShellSession
     False purgeResearchData
     False purgeCrashDumps
     False flushEventsQueue
     False resetLocalConfiguration  Invoke-S1AgentAction -AgentID <agent_id> -ResetLocalConfig
      True restartServices
     False markAsUpToDate
     False protect                  Invoke-S1AgentAction -AgentID <agent_id> -Protect
     False unprotect                Invoke-S1AgentAction -AgentID <agent_id> -Unprotect
     False revokeToken
     False purgeDB
     False controlCrashDumps
     False controlResearchData
     False eventsThrottling
     False configuration
     False migrateAgent
     False randomizeUUID
     False fileFetch
     False showApplications
     False showPassphrase
     False searchOnDeepVisibility
     False viewThreats
     False setCustomerIdentifier
      True enableRanger
      True disableRanger
```

### Initiate a scan
```PowerShell
PS > $Aborted = Get-S1Agent -ScanStatus aborted
PS > Invoke-S1AgentAction -AgentID $Aborted.id -Scan
Scan initiated for X agents
```

### Abort a scan
```PowerShell
PS > $Started = Get-S1Agent -ScanStatus started
PS > Invoke-S1AgentAction -AgentID $Started.id -AbortScan
Scan aborted for X agents
```

### Start-S1FetchFile
Initiate a fetch file command
```PowerShell
PS > $Agent = Get-S1Agent -Name "Deathstar"
PS > Start-S1FetchFile -AgentID $Agent.id -FilePath "/path/to/file" -Password ExecuteOrder66!
```

### Start-S1FetchLogs
Fetch logs from a SentinelOne agent named "Deathstar"
```PowerShell
PS > $Agent = Get-S1Agent -Name "Deathstar"
PS > Start-S1FetchLogs -AgentID $Agent.id
Fetch Logs initiated for 1 agents
```

### Send-S1Message
Send a command to a SentinelOne agent named "Deathstar"
```PowerShell
PS > $Agent = Get-S1Agent -Name "Deathstar"
PS > Send-S1Message -AgentID $Agent.id -Message "Do I execute order 66?"
```

### Start-S1NetworkQuarantine
Start network quarantine for a SentinelOne agent named "Deathstar"
```PowerShell
PS > $Agent = Get-S1Agent -Name "Deathstar"
PS > Start-S1NetworkQuarantine -AgentID $Agent.id
```

### Stop-S1NetworkQuarantine
Stop network quarantine for a SentinelOne agent named "Deathstar"
```PowerShell
PS > $Agent = Get-S1Agent -Name "Deathstar"
PS > Stop-S1NetworkQuarantine -AgentID $Agent.id
```

### Start-S1Reload
Reload the SentinelOne agent services for an agent named "Deathstar"
```PowerShell
PS > $Agent = Get-S1Agent -Name "Deathstar"
PS > Start-S1Reload -AgentID $Agent.id -Module "log"
PS > Start-S1Reload -AgentID $Agent.id -Module "static"
PS > Start-S1Reload -AgentID $Agent.id -Module "agent"
PS > Start-S1Reload -AgentID $Agent.id -Module "monitor"
```