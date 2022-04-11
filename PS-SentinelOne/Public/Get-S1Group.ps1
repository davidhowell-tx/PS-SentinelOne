function Get-S1Group {
    <#
    .SYNOPSIS
        Gets information related to SentinelOne Groups
    #>
    [CmdletBinding(DefaultParameterSetName="All")]
    Param(
        # Filter groups by name
        [Parameter(Mandatory=$True,ParameterSetName="Name")]
        [String]
        $Name,

        # Filter groups by group ID
        [Parameter(Mandatory=$True,ParameterSetName="GroupID")]
        [String[]]
        $GroupID,

        # Filter groups by site ID
        [Parameter(Mandatory=$False)]
        [String[]]
        $SiteID,

        # Filter groups by account ID
        [Parameter(Mandatory=$False)]
        [String[]]
        $AccountID,

        # Filter groups by type, i.e. Static or Dynamic
        [Parameter(Mandatory=$False)]
        [ValidateSet("static","dynamic")]
        [String]
        $Type,

        # Get a group based on its registration token
        [Parameter(Mandatory=$True,ParameterSetName="RegistrationToken")]
        [String]
        $RegistrationToken
    )
    Process {
        # Log the function and parameters being executed
        $InitializationLog = $MyInvocation.MyCommand.Name
        $MyInvocation.BoundParameters.GetEnumerator() | ForEach-Object { $InitializationLog = $InitializationLog + " -$($_.Key) $($_.Value)"}
        Write-Log -Message $InitializationLog -Level Informational

        $URI = "/web/api/v2.1/groups"
        $Parameters = @{}
        $Parameters.Add("limit", 200)
        if ($Name) { $Parameters.Add("name", $Name) }
        if ($GroupID) { $Parameters.Add("groupIds", ($GroupID -join ",") ) }
        if ($SiteID) { $Parameters.Add("siteIds", ($SiteID -join ",") ) }
        if ($AccountID) { $Parameters.Add("accountIds", ($AccountID -join ",") ) }
        if ($Type) { $Parameters.Add("type", $Type.ToLower()) }
        if ($RegistrationToken) { $Parameters.Add("registrationToken", $RegistrationToken) }
        $Response = Invoke-S1Query -URI $URI -Method GET -Parameters $Parameters -Recurse
        Write-Output $Response.data | Add-CustomType -CustomTypeName "SentinelOne.Group"
    }
}