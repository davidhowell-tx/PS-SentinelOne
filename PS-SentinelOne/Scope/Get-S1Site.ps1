function Get-S1Site {
    <#
    .SYNOPSIS
        Gets information related to SentinelOne sites
    
    .PARAMETER Name
        Get a site based on its name
    
    .PARAMETER SiteID
        Get a site by its ID
    
    .PARAMETER RegistrationToken
        Get a site based on its registration token
    
    .PARAMETER AccountID
        Filter sites list by their account ID
    
    .PARAMETER State
        Filter sites list by the site status, i.e. active, expired, or deleted

    .PARAMETER AvailableMoveSite
        Only return sites the user can move agents to

    .PARAMETER AdminOnly
        Only return sites the user has admin privileges to
    
    .NOTES Options that aren't implemented yet:
        createdAt, updatedAt, expiration, features,
        siteType, suite, healthStatus, isDefault,
        sortBy, sortOrder, externalId, countOnly,
        activeLicenses, totalLicenses, query
    #>
    [CmdletBinding(DefaultParameterSetName="All")]
    Param(
        [Parameter(Mandatory=$True,ParameterSetName="Name")]
        [String]
        $Name,

        [Parameter(Mandatory=$True,ParameterSetName="SiteID")]
        [String[]]
        $SiteID,

        [Parameter(Mandatory=$True,ParameterSetName="RegistrationToken")]
        [String]
        $RegistrationToken,

        [Parameter(Mandatory=$False)]
        [String[]]
        $AccountID,

        [Parameter(Mandatory=$False)]
        [ValidateSet("active","expired","deleted")]
        [String[]]
        $State,

        [Parameter(Mandatory=$True,ParameterSetName="AvailableMoveSite")]
        [Switch]
        $AvailableMoveSite,

        [Parameter(Mandatory=$True,ParameterSetName="AdminOnly")]
        [Switch]
        $AdminOnly
    )
    Process {
        # Log the function and parameters being executed
        $InitializationLog = $MyInvocation.MyCommand.Name
        $MyInvocation.BoundParameters.GetEnumerator() | ForEach-Object { $InitializationLog = $InitializationLog + " -$($_.Key) $($_.Value)"}
        Write-Log -Message $InitializationLog -Level Informational

        $URI = "/web/api/v2.0/sites"
        $Parameters = @{}
        if ($Name) { $Parameters.Add("name", $Name) }
        if ($SiteID) { $Parameters.Add("siteIds", ($SiteID -join ","))}
        if ($RegistrationToken) { $Parameters.Add("registrationToken", $RegistrationToken) }
        if ($AccountID) { $Parameters.Add("accountId", ($AccountID -join ",")) }
        if ($State) { $Parameters.Add("states", ($State -join ",")) }
        if ($AvailableMoveSite) { $Parameters.Add("availableMoveSites", "true") }
        if ($AdminOnly) { $Parameters.Add("adminOnly", "true") }
        $Response = Invoke-S1Query -URI $URI -Method GET -Parameters $Parameters -Recurse
        Write-Output $Response.data.sites
    }
}