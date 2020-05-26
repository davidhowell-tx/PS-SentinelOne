function Get-S1Account {
    <#
    .SYNOPSIS
        Gets information related to SentinelOne Accounts
    
    .PARAMETER Name
        Name of the account to retrieve

    .PARAMETER AccountID
        A list of Account IDs to filter results
    
    .NOTES Options not yet implemented:
        query, states, createdAt, updatedAt, expiration,
        totalLicenses, activeLicenses, accountType
        features, sortBy, sortOrder, isDefault
    #>
    [CmdletBinding(DefaultParameterSetName="All")]
    Param(
        [Parameter(Mandatory=$True,ParameterSetName="Name")]
        [String]
        $Name,

        [Parameter(Mandatory=$True,ParameterSetName="AccountID")]
        [String[]]
        $AccountID
    )
    Process {
        # Log the function and parameters being executed
        $InitializationLog = $MyInvocation.MyCommand.Name
        $MyInvocation.BoundParameters.GetEnumerator() | ForEach-Object { $InitializationLog = $InitializationLog + " -$($_.Key) $($_.Value)"}
        Write-Log -Message $InitializationLog -Level Informational

        $URI = "/web/api/v2.0/accounts"
        $Parameters = @{}
        switch ($PSCmdlet.ParameterSetName) {
            "Name" { $Parameters.Add("name", $Name) }
            "AccountID" { $Parameters.Add("ids", ($AccountID -join ",")) }
        }
        $Response = Invoke-S1Query -URI $URI -Method GET -Parameters $Parameters -Recurse
        Write-Output $Response.data
    }
  }