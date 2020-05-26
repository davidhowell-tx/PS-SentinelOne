function Get-S1Exclusion {
    <#
    .SYNOPSIS
        Retrieves information related to SentinelOne exclusions 
    


    .NOTES Options Implemented
        
    .NOTES Options not yet implemented 
         
    #>
    [CmdletBinding(DefaultParameterSetName="All")]
    Param(
        [Parameter(Mandatory=$False)]
        [Switch]
        $IncludeInherited,

        [Parameter(Mandatory=$False)]
        [String[]]
        $GroupID,

        [Parameter(Mandatory=$False)]
        [String[]]
        $SiteID,

        [Parameter(Mandatory=$False)]
        [String[]]
        $AccountID,

        [Parameter(Mandatory=$False)]
        [String[]]
        $UserID,

        [Parameter(Mandatory=$False)]
        [ValidateSet("windows", "windows_legacy", "macos", "linux")]
        [String[]]
        $OSType,

        [Parameter(Mandatory=$False)]
        [ValidateSet("suppress", "suppress_dynamic_only", "suppress_dfi_only", "disable_in_process_monitor", "disable_in_process_monitor_deep", "disable_all_monitors", "disable_all_monitors_deep")]
        [String[]]
        $Mode
    )
    Process {
        # Log the function and parameters being executed
        $InitializationLog = $MyInvocation.MyCommand.Name
        $MyInvocation.BoundParameters.GetEnumerator() | ForEach-Object { $InitializationLog = $InitializationLog + " -$($_.Key) $($_.Value)"}
        Write-Log -Message $InitializationLog -Level Informational
        
        $URI = "/web/api/v2.0/restrictions"
        $Parameters = @{}
        #$Parameters.Add("limit", 50)
        $Parameters.Add("type", "black_hash" )


        if ($GroupID) { $Parameters.Add("groupIds", ($GroupID -join ",") ) }
        if ($SiteID) { $Parameters.Add("siteIds", ($SiteID -join ",") ) }
        if ($AccountID) { $Parameters.Add("accountIds", ($AccountID -join ",") ) }
        if ($UserID) { $Parameters.Add("userIds", ($UserID -join ",") ) }
        if ($OSType) { $Parameters.Add("osTypes", ($OSType -join ",") ) }
        if ($Mode) { $Parameters.Add("modes", ($Mode -join ",") ) }
        if ($IncludeInherited) { $Parameters.Add("unified", $IncludeInherited) }

        
        $Response = Invoke-S1Query -URI $URI -Method GET -Parameters $Parameters -Recurse
        Write-Output $Response.data
    }
}