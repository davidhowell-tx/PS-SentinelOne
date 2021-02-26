function Get-S1Account {
    <#
    .SYNOPSIS
        Gets information related to SentinelOne Accounts
    
    .NOTES Options not yet implemented:
        query, states, createdAt, updatedAt, expiration,
        totalLicenses, activeLicenses, accountType
        features, sortBy, sortOrder, isDefault
    #>
    [CmdletBinding(DefaultParameterSetName="All")]
    Param(
        # Filter the accounts list to a specific name
        [Parameter(Mandatory=$False)]
        [String]
        $Name,

        # Filter the accounts list to specific account IDs
        [Parameter(Mandatory=$False)]
        [String[]]
        $AccountID,

        # Limit the number of retrieved accounts
        [Parameter()]
        [int]
        $Count,

        [Parameter(Mandatory=$False)]
        [ValidateSet(
            "accountType",
            "activeAgents",
            #"activeLicenses", # Returns a 500 error when tested
            "createdAt",
            "expiration",
            "id",
            "name",
            "numberOfSites",
            "state",
            #"totalLicenses", # Returns a 500 error when tested
            "updatedAt"
        )]
        [String]
        $SortBy,

        [Parameter(Mandatory=$False)]
        [ValidateSet("asc", "desc")]
        [String]
        $SortOrder,

        [Parameter(Mandatory=$False)]
        [Switch]
        $CountOnly
    )
    Process {
        # Log the function and parameters being executed
        $InitializationLog = $MyInvocation.MyCommand.Name
        $MyInvocation.BoundParameters.GetEnumerator() | ForEach-Object { $InitializationLog = $InitializationLog + " -$($_.Key) $($_.Value)"}
        Write-Log -Message $InitializationLog -Level Verbose

        $URI = "/web/api/v2.1/accounts"
        $MaxCount = 100
        $Parameters = @{}
        if ($SortBy) { $Parameters.Add("sortBy", $SortBy) }
        if ($SortOrder) { $Parameters.Add("sortOrder", $SortOrder) }
        if ($CountOnly) { $Parameters.Add("countOnly", $True) }
        if ($Name) { $Parameters.Add("name", $Name) }
        if ($AccountID) { $Parameters.Add("ids", ($AccountID -join ",")) }
        if ($Count) {
            $Response = Invoke-S1Query -URI $URI -Method GET -Parameters $Parameters -Count $Count -MaxCount $MaxCount
        } else {
            $Response = Invoke-S1Query -URI $URI -Method GET -Parameters $Parameters -Recurse -MaxCount $MaxCount
        }
        
        if ($CountOnly) {
            Write-Output $Response
        } else {
            Write-Output $Response.data
        }
    }
  }