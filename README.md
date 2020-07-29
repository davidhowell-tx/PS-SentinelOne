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
  * [Retrieve agents for a certain domain](#retrieve-agents-for-a-certain-domain)
  * [Retrieve agents with macOS](#retrieve-agents-with-macos)
  * [Retrieve agents in detect mode](#retrieve-agents-in-detect-mode)
  * [Retrieve infected agents](#retrieve-infected-agents)
  * [Retrieve passphrase for an agent](#retrieve-passphrase-for-an-agent)
* Exclusions (Whitelist)
  * [Retrieve hash exclusions for a site](#retrieve-hash-exclusions-for-a-site)
  * [Retrieve path exclusions for a site](#retrieve-path-exclusions-for-a-site)
* Blacklist
  * [Retrieve blacklist for a site](#retrieve-blacklist-for-a-site)
* Applications
  * [Retrieve installed applications for a specific agent](#retrieve-installed-applications-for-a-specific-agent)
  * [Retrieve application instances and versions by application name](#retrieve-application-instances-and-versions-by-application-name)
* Agent Actions
  * [Get Available Actions](#get-available-actions)
  * [Move agent to different group](#move-agent-to-different-group)
  * [Move agent to different site](#move-agent-to-different-site)
  * [Initiate a scan](#initiate-a-scan)
  * [Abort a scan](#abort-a-scan)
  * [Fetch a file](#fetch-a-file)
  * [Fetch logs from agent](#fetch-logs-from-agent)
  * [Send a message to an agent](#send-a-message-to-an-agent)
  * [Start network quarantine for an agent](#start-network-quarantine-for-an-agent)
  * [Stop network quarantine for an agent](#stop-network-quarantine-for-an-agent)

#### Retrieve accounts list
```PowerShell
PS > Get-S1Account
```

#### Retrieve sites list
```PowerShell
PS > Get-S1Site
```

#### Retrieve sites for account
```PowerShell
PS > $Account = Get-S1Account -Name "My Account"
PS > Get-S1Site -AccountID $Account.id
```

#### Retrieve active sites
```PowerShell
PS > Get-S1Site -State active # Tab complete capability
```

#### Retrieve a site by name
```PowerShell
PS > Get-S1Site -Name "My Site"
```

#### Retrieve all groups in a specific site
```PowerShell
PS > $Site = Get-S1Site -Name "My Site"
PS > $Groups = Get-S1Group -SiteID $Site.id
```

#### Retrieve a specific group in a specific site
```PowerShell
PS > $Site = Get-S1Site -Name "My Site"
PS > $Groups = Get-S1Group -SiteID $Site.id -Name "Default Group"
```

#### Create a new group
```PowerShell
PS > $Site = Get-S1Site -Name "My Site"
PS > $NewGroup = New-S1Group -Name "Test" -SiteID $Site.id
```

#### Delete a group
```PowerShell
PS > $Site = Get-S1Site -Name "My Site"
PS > $Group = New-S1Group -Name "Test" -SiteID $Site.id
PS > Remove-S1Group -GroupID $Group.id

success
-------
   True
```

#### Retrieve agents in a group
```PowerShell
PS > $Group = Get-S1Group -Name "Default Group"
PS > Get-S1Agent -GroupID $Group.id
```

#### Retrieve agents for a certain domain
```PowerShell
PS > Get-S1Agent -Domain acme
```

#### Retrieve agents with macOS
```PowerShell
PS > Get-S1Agent -OSType macos
```

#### Retrieve agents in detect mode
```PowerShell
PS > Get-S1Agent -MitigationMode detect
```

#### Retrieve infected agents
```PowerShell
PS > Get-S1Agent -Infected true
```

#### Retrieve passphrase for an agent
```PowerShell
PS > $Agent = Get-S1Agent -Name "Deathstar"
PS > Get-S1Passphrase -AgentID $Agent.id
```

#### Retrieve hash exclusions for a site
```PowerShell
PS > $TargetSite = Get-S1Site -Name "Rebel Alliance"
PS > Get-S1Exclusion -SiteID $TargetSite.id -Type white_hash
```

#### Retrieve path exclusions for a site
```PowerShell
PS > $TargetSite = Get-S1Site -Name "Rebel Alliance"
PS > Get-S1Exclusion -SiteID $TargetSite.id -Type path
```

#### Retrieve blacklist for a site
```PowerShell
PS > $TargetSite = Get-S1Site -Name "Rebel Alliance"
PS > Get-S1Blacklist -SiteID $TargetSite.id
```

#### Retrieve installed applications for a specific agent
```PowerShell
PS > $Agent = Get-S1Agent -Name "Deathstar"
PS > Get-S1Application -AgentID $Agent.id
```

#### Retrieve application instances and versions by application name
```PowerShell
PS > $ChromeInstances = Get-S1Application -ApplicationName "Google Chrome"
```

#### Get Available Actions
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

#### Move agent to different group
```PowerShell
PS > $Agent = Get-S1Agent -Name "Deathstar"
PS > $TargetGroup = Get-S1Group -Name "Destroyed Battle Stations"
PS > Move-S1Agent -AgentID $Agents.id -TargetGroupID $TargetGroup.id
```

#### Move agent to different site
```PowerShell
PS > $Agent = Get-S1Agent -Name "Kashyyyk"
PS > $TargetSite = Get-S1Site -Name "Rebel Alliance"
PS > Move-S1Agent -AgentID $Agents.id -TargetSiteID $TargetSite.id
```

#### Initiate a scan
```PowerShell
PS > $Agents = Get-S1Agent -ScanStatus aborted
PS > Invoke-S1AgentAction -AgentID $Agents.id -Scan
Scan initiated for X agents
```

#### Abort a scan
```PowerShell
PS > $Started = Get-S1Agent -ScanStatus started
PS > Invoke-S1AgentAction -AgentID $Started.id -AbortScan
Scan aborted for X agents
```

#### Fetch a file
```PowerShell
PS > $Agent = Get-S1Agent -Name "Deathstar"
PS > Invoke-S1FetchFile -AgentID $Agent.id -FilePath "/path/to/file" -Password ExecuteOrder66!

success
-------
   True
```

#### Fetch logs from agent
```PowerShell
PS > $Agent = Get-S1Agent -Name "Deathstar"
PS > Invoke-S1AgentAction -AgentID $Agent.id -FetchLogs
Fetch Logs initiated for 1 agents
```

#### Send a message to an agent
```PowerShell
PS > $Agent = Get-S1Agent -Name "Deathstar"
PS > Invoke-S1AgentAction -AgentID $Agent.id -SendMessage "Do I execute order 66?"
```

#### Start network quarantine for an agent
```PowerShell
PS > $Agent = Get-S1Agent -Name "Deathstar"
PS > Invoke-S1AgentAction -AgentID $Agent.id -DisconnectFromNetwork
```

#### Stop network quarantine for an agent
```PowerShell
PS > $Agent = Get-S1Agent -Name "Deathstar"
PS > Invoke-S1AgentAction -AgentID $Agent.id -ReconnectToNetwork
```