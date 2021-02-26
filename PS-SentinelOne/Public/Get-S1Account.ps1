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
        [Parameter(Mandatory=$True,ParameterSetName="Name")]
        [String]
        $Name,

        # Filter the accounts list to specific account IDs
        [Parameter(Mandatory=$True,ParameterSetName="AccountID")]
        [String[]]
        $AccountID,

        # Limit the number of retrieved accounts
        [Parameter()]
        [int]
        $Count
    )
    Process {
        # Log the function and parameters being executed
        $InitializationLog = $MyInvocation.MyCommand.Name
        $MyInvocation.BoundParameters.GetEnumerator() | ForEach-Object { $InitializationLog = $InitializationLog + " -$($_.Key) $($_.Value)"}
        Write-Log -Message $InitializationLog -Level Informational

        $URI = "/web/api/v2.1/accounts"
        $MaxCount = 100
        $Parameters = @{}
        switch ($PSCmdlet.ParameterSetName) {
            "Name" { $Parameters.Add("name", $Name) }
            "AccountID" { $Parameters.Add("ids", ($AccountID -join ",")) }
        }
        if ($Count) {
            $Response = Invoke-S1Query -URI $URI -Method GET -Parameters $Parameters -Count $Count -MaxCount $MaxCount
        } else {
            $Response = Invoke-S1Query -URI $URI -Method GET -Parameters $Parameters -Recurse -MaxCount $MaxCount
        }
        
        Write-Output $Response.data
    }
  }