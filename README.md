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

### In Session

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

### Persisted

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

### Sites
Retrieve your Sites list
```PowerShell
PS > Get-S1Site
```

Retrieve only Active sites
```PowerShell
PS > Get-S1Site -State active # Tab complete capability
```

Get a Site by its Name
```PowerShell
PS > Get-S1Site -Name "My Site"
```