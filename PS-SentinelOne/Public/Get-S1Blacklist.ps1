function Get-S1Blacklist {
    <#
    .SYNOPSIS
        Retrieves information related to SentinelOne blacklist 
    #>
    [CmdletBinding(DefaultParameterSetName="All")]
    Param(
        [Parameter(Mandatory=$False)]
        [String]
        $Hash,

        [Parameter(Mandatory=$False)]
        [String]
        [ValidateSet("true", "false")]
        $IncludeInherited,

        [Parameter(Mandatory=$False)]
        [ValidateSet("windows", "windows_legacy", "macos", "linux")]
        [String[]]
        $OSType,

        [Parameter(Mandatory=$False)]
        [String[]]
        $BlacklistID,

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
        #$Parameters.Add("limit", 50)
        $Parameters.Add("type", "black_hash" )

        if ($Hash) { $Parameters.Add("value", $Hash) }
        if ($IncludeInherited) { $Parameters.Add("unified", $IncludeInherited) }
        if ($OSType) { $Parameters.Add("osTypes", ($OSType -join ",") ) }
        if ($BlacklistID) { $Parameters.Add("ids", ($BlacklistID -join ",") ) }
        if ($UserID) { $Parameters.Add("userIds", ($UserID -join ",") ) }
        if ($GroupID) { $Parameters.Add("groupIds", ($GroupID -join ",") ) }
        if ($SiteID) { $Parameters.Add("siteIds", ($SiteID -join ",") ) }
        if ($AccountID) { $Parameters.Add("accountIds", ($AccountID -join ",") ) }
        
        $Response = Invoke-S1Query -URI $URI -Method GET -Parameters $Parameters -Recurse
        Write-Output $Response.data
    }
}