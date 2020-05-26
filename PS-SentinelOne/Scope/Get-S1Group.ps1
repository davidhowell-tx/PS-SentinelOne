function Get-S1Group {
    <#
    .SYNOPSIS
        Gets information related to SentinelOne Groups
    
    .PARAMETER Name
        Filter groups by name
    
    .PARAMETER GroupID
        Filter groups by group ID

    .PARAMETER SiteID
        Filter groups by site ID
    
    .PARAMETER AccountID
        Filter groups by account ID

    .PARAMETER Type
        Filter groups by type, i.e. Static or Dynamic

    .PARAMETER RegistrationToken
        Get a group based on its registration token
    
    .NOTES Options not yet implemented:
        updatedAt__gt, type, updatedAt__gte, updatedAt__lt, updatedAt__lte,
        rank, sortBy, sortOrder, query 

    #>
    [CmdletBinding(DefaultParameterSetName="All")]
    Param(
        [Parameter(Mandatory=$True,ParameterSetName="Name")]
        [String]
        $Name,

        [Parameter(Mandatory=$True,ParameterSetName="GroupID")]
        [String[]]
        $GroupID,

        [Parameter(Mandatory=$False)]
        [String[]]
        $SiteID,

        [Parameter(Mandatory=$False)]
        [String[]]
        $AccountID,

        [Parameter(Mandatory=$False)]
        [ValidateSet("Static","Dynamic")]
        [String]
        $Type,

        [Parameter(Mandatory=$True,ParameterSetName="RegistrationToken")]
        [String]
        $RegistrationToken
    )
    Process {
        # Log the function and parameters being executed
        $InitializationLog = $MyInvocation.MyCommand.Name
        $MyInvocation.BoundParameters.GetEnumerator() | ForEach-Object { $InitializationLog = $InitializationLog + " -$($_.Key) $($_.Value)"}
        Write-Log -Message $InitializationLog -Level Informational

        $URI = "/web/api/v2.0/groups"
        $Parameters = @{}
        if ($Name) { $Parameters.Add("name", $Name) }
        if ($GroupID) { $Parameters.Add("groupIds", ($GroupID -join ",") ) }
        if ($SiteID) { $Parameters.Add("siteIds", ($SiteID -join ",") ) }
        if ($AccountID) { $Parameters.Add("accountIds", ($AccountID -join ",") ) }
        if ($Type) { $Parameters.Add("type", $Type) }
        if ($RegistrationToken) { $Parameters.Add("registrationToken", $RegistrationToken) }
        $Response = Invoke-S1Query -URI $URI -Method GET -Parameters $Parameters -Recurse
        Write-Output $Response.data
    }
    End {}
}