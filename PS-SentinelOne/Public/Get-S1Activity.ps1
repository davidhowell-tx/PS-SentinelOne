function Get-S1Activity {
    <#
    .SYNOPSIS
        Retrieve Activities from the Activities log
    
    .EXAMPLE
        Return all activities for January 2020
        Get-S1Activity -CreatedAfter (Get-Date "01/01/2020") -CreatedBefore (Get-Date "02/01/2020")
    
    .NOTES Options not yet implemented:
        sortBy, sortOrder 
    #>
    [CmdletBinding()]
    Param(
        # Return only these activity codes (comma-separated list)
        [Parameter()]
        [int[]]
        $ActivityType,

        # Filter by date, created after this time
        [Parameter()]
        [DateTime]
        $CreatedAfter,

        # Filter by date, created before this time
        [Parameter()]
        [DateTime]
        $CreatedBefore,

        # Filter by the email of the user that invoked the activity
        [Parameter()]
        [String[]]
        $UserEmail,

        # Filter by the ID of the user that invoked the activity
        [Parameter()]
        [String[]]
        $UserID,

        # Filter by threat ID
        [Parameter()]
        [String[]]
        $ThreatID,

        # Filter by rule ID
        [Parameter()]
        [String[]]
        $RuleID,

        # Include hidden activities
        [Parameter()]
        [Switch]
        $IncludeHidden,

        # Limit result size
        [Parameter()]
        [int]
        $Count,

        # Only return the number of results that would be returned
        [Parameter(Mandatory=$False)]
        [Switch]
        $CountOnly,

        # Filter by account ID
        [Parameter()]
        [String[]]
        $AccountID,

        # Filter by site ID
        [Parameter()]
        [String[]]
        $SiteID,

        # Filter by group ID
        [Parameter()]
        [String[]]
        $GroupID,

        # Filter by agent ID
        [Parameter()]
        [String[]]
        $AgentID,

        # Filter by specific activity IDs
        [Parameter()]
        [String[]]
        $ActivityID,

        # Sort results by a property
        [Parameter(Mandatory=$False)]
        [ValidateSet(
            "activityType",
            "createdAt",
            "id"
        )]
        [String]
        $SortBy,

        # Sort order
        [Parameter(Mandatory=$False)]
        [ValidateSet("asc", "desc")]
        [String]
        $SortOrder
    )
    Process {
        # Log the function and parameters being executed
        $InitializationLog = $MyInvocation.MyCommand.Name
        $MyInvocation.BoundParameters.GetEnumerator() | ForEach-Object { $InitializationLog = $InitializationLog + " -$($_.Key) $($_.Value)"}
        Write-Log -Message $InitializationLog -Level Verbose

        $URI = "/web/api/v2.1/activities"
        [uint32]$MaxCount = 1000
        $Parameters = @{}
        if ($ActivityType) { $Parameters.Add("activityTypes", ($ActivityType -join ",") ) }
        if ($CreatedAfter -and $CreatedBefore) {
            [int64]$CreatedAfterUnix = Format-Date -InputObject $CreatedAfter -UnixMS
            [int64]$CreatedBeforeUnix = Format-Date -InputObject $CreatedBefore -UnixMS
            $Parameters.Add("createdAt__between", "$CreatedAfterUnix-$CreatedBeforeUnix")
        } elseif ($CreatedAfter) {
            $CreatedAfterString = Format-Date -InputObject $CreatedAfter -UnixMS
            $Parameters.Add("createdAt__gte", $CreatedAfterString)
        } elseif ($CreatedBefore) {
            $CreatedBeforeString = Format-Date -InputObject $CreatedBefore -UnixMS
            $Parameters.Add("createdAt__lte", $CreatedBeforeString)
        }
        if ($UserEmail) { $Parameters.Add("userEmails", ($UserEmail -join ",") ) }
        if ($UserID) { $Parameters.Add("userIds", ($UserID -join ",") ) }
        if ($ThreatID) { $Parameters.Add("threatIds", ($ThreatID -join ",") ) }
        if ($RuleID) { $Parameters.Add("ruleIds", ($RuleID -join ",") ) }
        if ($IncludeHidden) { $Parameters.Add("includeHidden", $True) }
        if ($CountOnly) { $Parameters.Add("countOnly", $True) }
        if ($AccountID) { $Parameters.Add("accountIds", ($AccountID -join ",") ) }
        if ($SiteID) { $Parameters.Add("siteIds", ($SiteID -join ",") ) }
        if ($GroupID) { $Parameters.Add("groupIds", ($GroupID -join ",") ) }
        if ($AgentID) { $Parameters.Add("agentIds", ($AgentID -join ",") ) }
        if ($ActivityID) { $Parameters.Add("ids", ($ActivityID -join ",") ) }
        if ($SortBy) { $Parameters.Add("sortBy", $SortBy) }
        if ($SortOrder) { $Parameters.Add("sortOrder", $SortOrder) }

        if ($Count) {
            $Response = Invoke-S1Query -URI $URI -Method GET -Parameters $Parameters -Count $Count -MaxCount $MaxCount
        } else {
            $Response = Invoke-S1Query -URI $URI -Method GET -Parameters $Parameters -Recurse -MaxCount $MaxCount
        }

        if ($CountOnly) {
            Write-Output $Response
        } elseif ($Count) {
            Write-Output $Response.data[0..($Count-1)] | Add-CustomType -CustomTypeName "SentinelOne.Activity"
        } else {
            Write-Output $Response.data | Add-CustomType -CustomTypeName "SentinelOne.Activity"
        }
    }
}