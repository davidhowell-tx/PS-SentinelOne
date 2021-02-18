function Get-S1Activity {
    <#
    .SYNOPSIS
        Retrieve Activities from the Activities log
    
    .PARAMETER ActivityType
        Return only these activity codes (comma-separated list)
    
    .PARAMETER CreatedAfter
        Return activities created after or at this timestamp

    .PARAMETER CreatedBefore
        Return activities created before or at this timestamp

    .PARAMETER UserEmail
        Email of the user who invoked the activity (if applicable)
    
    .PARAMETER UserID
        The user who invoked the activity (if applicable)

    .PARAMETER ActivityID
        Filter activities by specific activity IDs

    .PARAMETER AccountID
        List of Account IDs to filter by

    .PARAMETER SiteID
        List of Site IDs to filter by

    .PARAMETER GroupID
        List of Group IDs to filter by

    .PARAMETER AgentID
        Return activities related to specified agents

    .PARAMETER ThreatID
        Return activities related to specified threats.

    .PARAMETER IncludeHidden
        Include internal activities hidden from display
    
    .EXAMPLE
        Return all activities for January 2020
        Get-S1Activity -CreatedAfter (Get-Date "01/01/2020") -CreatedBefore (Get-Date "02/01/2020")
    
    .NOTES Options not yet implemented:
        sortBy, sortOrder 
    #>
    [CmdletBinding()]
    Param(
        [Parameter()]
        [int[]]
        $ActivityType,

        [Parameter()]
        [DateTime]
        $CreatedAfter,

        [Parameter()]
        [DateTime]
        $CreatedBefore,

        [Parameter()]
        [String[]]
        $UserEmail,

        [Parameter()]
        [String[]]
        $UserID,

        [Parameter()]
        [String[]]
        $ActivityID,

        [Parameter()]
        [String[]]
        $AccountID,

        [Parameter()]
        [String[]]
        $SiteID,

        [Parameter()]
        [String[]]
        $GroupID,

        [Parameter()]
        [String[]]
        $AgentID,

        [Parameter()]
        [String[]]
        $ThreatID,

        [Parameter()]
        [Switch]
        $IncludeHidden
    )
    Process {
        # Log the function and parameters being executed
        $InitializationLog = $MyInvocation.MyCommand.Name
        $MyInvocation.BoundParameters.GetEnumerator() | ForEach-Object { $InitializationLog = $InitializationLog + " -$($_.Key) $($_.Value)"}
        Write-Log -Message $InitializationLog -Level Informational

        $URI = "/web/api/v2.1/activities"
        $Parameters = @{}
        if ($ActivityType) { $Parameters.Add("activityTypes", ($ActivityType -join ",") ) }
        if ($ActivityID) { $Parameters.Add("ids", ($ActivityID -join ",") ) }
        if ($AccountID) { $Parameters.Add("accountIds", ($AccountID -join ",") ) }
        if ($SiteID) { $Parameters.Add("siteIds", ($SiteID -join ",") ) }
        if ($GroupID) { $Parameters.Add("groupIds", ($GroupID -join ",") ) }
        if ($AgentID) { $Parameters.Add("agentIds", ($AgentID -join ",") ) }
        if ($ThreatID) { $Parameters.Add("threatIds", ($ThreatID -join ",") ) }
        if ($UserID) { $Parameters.Add("userIds", ($UserID -join ",") ) }
        if ($IncludeHidden) { $Parameters.Add("includeHidden", "true") }
        if ($UserEmail) { $Parameters.Add("userEmails", ($UserEmail -join ",") ) }

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

        $Response = Invoke-S1Query -URI $URI -Method GET -Parameters $Parameters -Recurse
        Write-Output $Response.data
    }
}