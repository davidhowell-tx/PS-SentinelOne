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

* Accounts
  * [Get-S1Account](#get-s1account)
* Sites
  * [Get-S1Site](#get-s1site)
* Groups
  * [Get-S1Group](#get-s1group)
  * [New-S1Group](#new-s1group)
  * [Remove-S1Group](#remove-s1group)
* Agents
  * [Get-S1Agent](#get-s1agent)
* Agent Actions
  * [Start-S1Scan](#start-s1scan)
  * [Stop-S1Scan](#stop-s1scan)
  * [Start-S1FetchFile](#start-s1fetchfile)
  * [Start-S1FetchLogs](#start-s1fetchlogs)
  * [Send-S1Message](#send-s1message)

### Get-S1Account
Retrieve available accounts list
```PowerShell
PS > Get-S1Account
```

### Get-S1Site
Retrieve your Sites list
```PowerShell
PS > Get-S1Site
```

Retrieve sites for an account named "My Account"
```PowerShell
PS > $Account = Get-S1Account -Name "My Account"
PS > Get-S1Site -AccountID $Account.id
```

Retrieve only Active sites
```PowerShell
PS > Get-S1Site -State active # Tab complete capability
```

Get a Site by its Name
```PowerShell
PS > Get-S1Site -Name "My Site"
```

### Get-S1Group
Retrieve groups in the site "My Site"
```PowerShell
PS > $Site = Get-S1Site -Name "My Site"
PS > $Groups = Get-S1Group -SiteID $Site.id
```

Retrieve the "Default Group" group in the site "My Site"
```PowerShell
PS > $Site = Get-S1Site -Name "My Site"
PS > $Group = Get-S1Group -SiteID $Site.id -Name "Default Group"
```

### New-S1Group
Create a new group called "Test" in the site "My Site"
```PowerShell
PS > $Site = Get-S1Site -Name "My Site"
PS > $NewGroup = New-S1Group -Name "Test" -SiteID $Site.id
```

### Remove-S1Group
Remove a group called "Test" in the site "My Site"
```PowerShell
PS > $Site = Get-S1Site -Name "My Site"
PS > $Group = New-S1Group -Name "Test" -SiteID $Site.id
PS > Remove-S1Group -GroupID $Group.id

success
-------
   True
```

### Get-S1Agent
```PowerShell
PS > $Group = Get-S1Group -Name "Default Group"
PS > Get-S1Agent -GroupID $Group.id
```

### Start-S1Scan
Initiate a scan for all agents with aborted scans
```PowerShell
PS > $Aborted = Get-S1Agent -ScanStatus aborted
PS > Start-S1Scan -AgentID $Aborted.id
Scan initiated for X agents
```
### Stop-S1Scan
Abort scans for all agents with running scans
```PowerShell
PS > $Started = Get-S1Agent -ScanStatus started
PS > Stop-S1Scan -AgentID $Started.id
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