function New-S1Blacklist {
    <#
    .SYNOPSIS
        Creates a new blacklist entry in SentinelOne 
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$True)]
        [String]
        $Hash,

        [Parameter(Mandatory=$False)]
        [String]
        $Description,

        [Parameter(Mandatory=$True)]
        [ValidateSet("windows", "macos", "linux")]
        [String]
        $OSType,

        [Parameter(Mandatory=$True,ParameterSetName="GroupLevel")]
        [String]
        $GroupID,

        [Parameter(Mandatory=$True,ParameterSetName="SiteLevel")]
        [String]
        $SiteID,

        [Parameter(Mandatory=$True,ParameterSetName="AccountLevel")]
        [String]
        $AccountID
    )
    Process {
        # Log the function and parameters being executed
        $InitializationLog = $MyInvocation.MyCommand.Name
        $MyInvocation.BoundParameters.GetEnumerator() | ForEach-Object { $InitializationLog = $InitializationLog + " -$($_.Key) $($_.Value)"}
        Write-Log -Message $InitializationLog -Level Informational

        $Body = @{
            data = @{
                type = "black_hash"
                osType = $OSType
                value = $Hash
                description = $Description
            }
            filter = @{}
        }

        if ($GroupID) { $Body.filter.Add("groupIds", @($GroupID -join ",")) }
        if ($SiteID) { $Body.filter.Add("siteIds", @($SiteID -join ",")) }
        if ($AccountID) { $Body.filter.Add("accountIds", @($AccountID -join ",")) }
        
        $URI = "/web/api/v2.1/restrictions"
        $Response = Invoke-S1Query -URI $URI -Method POST -Body ($Body | ConvertTo-Json) -ContentType "application/json"
        Write-Output $Response.data
    }
}