function Get-S1Exclusion {
    <#
    .SYNOPSIS
        Retrieves information related to SentinelOne exclusions
    #>
    [CmdletBinding(DefaultParameterSetName="All")]
    Param(
        [Parameter(Mandatory=$False)]
        [ValidateSet(
            "path",
            "certificate",
            "browser",
            "file_type",
            "white_hash"
        )]
        [String]
        $Type,

        [Parameter(Mandatory=$False)]
        [ValidateSet("true","false")]
        [String]
        $IncludeInherited,

        [Parameter(Mandatory=$False)]
        [ValidateSet(
            "windows",
            "windows_legacy",
            "macos",
            "linux")]
        [String[]]
        $OSType,

        [Parameter(Mandatory=$False)]
        [ValidateSet(
            "suppress",
            "suppress_dynamic_only",
            "suppress_dfi_only",
            "disable_in_process_monitor",
            "disable_in_process_monitor_deep",
            "disable_all_monitors",
            "disable_all_monitors_deep"
        )]
        [String[]]
        $Mode,

        [Parameter(Mandatory=$False)]
        [String]
        $Value,

        [Parameter(Mandatory=$False)]
        [String]
        $Search,

        [Parameter(Mandatory=$False)]
        [String[]]
        $ExclusionID,

        [Parameter(Mandatory=$False)]
        [String[]]
        $UserID,

        [Parameter(Mandatory=$False)]
        [String[]]
        $GroupID,

        [Parameter(Mandatory=$False)]
        [String[]]
        $SiteID,

        [Parameter(Mandatory=$False)]
        [String[]]
        $AccountID
    )
    Process {
        # Log the function and parameters being executed
        $InitializationLog = $MyInvocation.MyCommand.Name
        $MyInvocation.BoundParameters.GetEnumerator() | ForEach-Object { $InitializationLog = $InitializationLog + " -$($_.Key) $($_.Value)"}
        Write-Log -Message $InitializationLog -Level Informational
        
        $URI = "/web/api/v2.1/restrictions"
        $Parameters = @{}
        
        if ($Type) { $Parameters.Add("type", $Type) }
        if ($IncludeInherited) { $Parameters.Add("unified", $IncludeInherited) }
        if ($OSType) { $Parameters.Add("osTypes", ($OSType -join ",") ) }
        if ($Mode) { $Parameters.Add("modes", ($Mode -join ",") ) }
        if ($Value) { $Parameters.Add("value", $Value) }
        if ($Search) { $Parameters.Add("query", $Search) }
        if ($ExclusionID) { $Parameters.Add("ids", ($ExclusionID -join ",") ) }
        if ($UserID) { $Parameters.Add("userIds", ($UserID -join ",") ) }
        if ($GroupID) { $Parameters.Add("groupIds", ($GroupID -join ",") ) }
        if ($SiteID) { $Parameters.Add("siteIds", ($SiteID -join ",") ) }
        if ($AccountID) { $Parameters.Add("accountIds", ($AccountID -join ",") ) }
        
        $Response = Invoke-S1Query -URI $URI -Method GET -Parameters $Parameters -Recurse
        Write-Output $Response.data
    }
}