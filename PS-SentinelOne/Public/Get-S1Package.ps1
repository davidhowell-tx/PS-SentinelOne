function Get-S1Package {
    <#
    .SYNOPSIS
        Retrieve a deployable package list from the management console
    
    .PARAMETER OSType
        Filter packages by the targeted OS Type, ie. Windows, MacOS, Linux, etc.
    
    .PARAMETER Status
        Filter packages by the release status, ie. Beta, EA, GA, etc.

    .PARAMETER PackageType
        Filter packages by the package type, ie. Agent, Ranger, Agent and Ranger
    
    .PARAMETER FileExtension
        Filter packages by file extension, ie. msi, exe, deb, rpm, tar, etc.
    
    .PARAMETER Query
        Filter packages with a free-text search
    
    .PARAMETER Version
        Filter packages by the version number
    
    .PARAMETER PackageID
        Filter packages by the package id value
    
    .PARAMETER AccountID
        Filter packages by Account scope
    
    .PARAMETER SiteId
        Filter packages by Site scope
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$False)]
        [ValidateSet(
            "windows",
            "windows_legacy",
            "macos",
            "linux",
            "linux_k8s",
            "sdk"
        )]
        [String[]]
        $OSType,

        [Parameter(Mandatory=$False)]
        [ValidateSet(
            "beta",
            "ea",
            "ga",
            "other"
        )]
        [String[]]
        $Status,

        [Parameter(Mandatory=$False)]
        [ValidateSet(
            "Agent",
            "Ranger",
            "AgentAndRanger"
        )]
        [String]
        $PackageType,

        [Parameter(Mandatory=$False)]
        [ValidateSet(
            ".msi",
            ".exe",
            ".deb",
            ".rpm",
            ".bsx",
            ".pkg",
            ".tar",
            ".zip",
            ".gz",
            "unknown"
        )]
        [String]
        $FileExtension,

        [Parameter(Mandatory=$False)]
        [String]
        $Query,

        [Parameter(Mandatory=$False)]
        [String]
        $Version,

        [Parameter()]
        [String[]]
        $PackageID,

        [Parameter()]
        [String[]]
        $AccountID,

        [Parameter()]
        [String[]]
        $SiteID
    )
    Process {
        # Log the function and parameters being executed
        $InitializationLog = $MyInvocation.MyCommand.Name
        $MyInvocation.BoundParameters.GetEnumerator() | ForEach-Object { $InitializationLog = $InitializationLog + " -$($_.Key) $($_.Value)"}
        Write-Log -Message $InitializationLog -Level Informational

        $URI = "/web/api/v2.1/update/agent/packages"
        [uint32]$MaxCount = 100
        $Parameters = @{}
        if ($OSType) { $Parameters.Add("osTypes", ($OSType -join ",") ) }
        if ($Status) { $Parameters.Add("status", ($Status -join ",") ) }
        if ($PackageType) { $Parameters.Add("packageTypes", $PackageType ) }
        if ($FileExtension) { $Parameters.Add("fileExtension", $FileExtension ) }
        if ($Query) { $Parameters.Add("query", $Query ) }
        if ($Version) { $Parameters.Add("version", $Version ) }
        if ($PackageID) { $Parameters.Add("ids", ($PackageID -join ",") ) }
        if ($AccountID) { $Parameters.Add("accountIds", ($AccountID -join ",") ) }
        if ($SiteID) { $Parameters.Add("siteIds", ($SiteID -join ",") ) }

        $Response = Invoke-S1Query -URI $URI -Method GET -Parameters $Parameters -Recurse -MaxCount $MaxCount
        Write-Output $Response.data
    }
}