function Get-S1Package {
    <#
    .SYNOPSIS
        Retrieve a deployable package list from the management console
    #>
    [CmdletBinding()]
    Param(
        [Parameter()]
        [ValidateSet(
            ".msi",
            ".exe",
            ".deb",
            ".rpm",
            ".bsx",
            ".pkg",
            ".tar",
            ".zip",
            "unknown"
        )]
        [String]
        $FileExtension,

        [Parameter()]
        [ValidateSet(
            "Agent",
            "Ranger",
            "AgentAndRanger"
        )]
        [String[]]
        $PackageType,

        [Parameter()]
        [ValidateSet(
            "windows",
            "windows_legacy",
            "macos",
            "linux"
        )]
        [String]
        $OSType,

        [Parameter()]
        [String]
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
        $Parameters = @{}
        if ($PackageID) { $Parameters.Add("ids", ($PackageID -join ",") ) }
        if ($AccountID) { $Parameters.Add("accountIds", ($AccountID -join ",") ) }
        if ($SiteID) { $Parameters.Add("siteIds", ($SiteID -join ",") ) }
        if ($FileExtension) { $Parameters.Add("fileExtension", $FileExtension ) }
        if ($PackageType) { $Parameters.Add("packageTypes", ($PackageType -join ",") ) }
        if ($OSType) { $Parameters.Add("osTypes", ($OSType -join ",") ) }

        $Response = Invoke-S1Query -URI $URI -Method GET -Parameters $Parameters -Recurse
        Write-Output $Response.data
    }
}