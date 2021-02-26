function Get-S1DvEvents {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$True)]
        $Query,

        [Parameter(Mandatory=$False)]
        [ValidateSet(1, 10, 100, 1000, 2000, 5000, 10000, 20000)]
        $Limit = 1000,

        [Parameter(Mandatory=$True,ParameterSetName="TimeFrame")]
        [ValidateSet("Last Hour","Last 24 Hours","Today", "Last 48 Hours", "Last 7 Days", "Last 30 Days", "This Month", "Last 2 Months", "Last 3 Months")]
        [String]
        $TimeFrame,

        [Parameter(Mandatory=$True,ParameterSetName="CustomTime")]
        [DateTime]
        $ToDate,

        [Parameter(Mandatory=$True,ParameterSetName="CustomTime")]
        [DateTime]
        $FromDate
    )

    # Log the function and parameters being executed
    $InitializationLog = $MyInvocation.MyCommand.Name
    $MyInvocation.BoundParameters.GetEnumerator() | ForEach-Object { $InitializationLog = $InitializationLog + " -$($_.Key) $($_.Value)"}
    Write-Log -Message $InitializationLog -Level Informational

    # Submit the Query
    switch ($PSCmdlet.ParameterSetName) {
        "TimeFrame" {
            $DvQuery = New-S1DvQuery -TimeFrame $TimeFrame -Query $Query -Limit $Limit
        }
        "CustomTime" {
            $DvQuery = New-S1DvQuery -ToDate $ToDate -FromDate $FromDate -Query $Query -Limit $Limit
        }
    }

    # Check the status of the query every 5 seconds until it is complete
    $Status = Get-S1DvQueryStatus -QueryID $DVQuery.queryId
    while ($Status.responseState -ne "FINISHED") {
        Start-Sleep -Seconds 5
        $Status = Get-S1DvQueryStatus -QueryID $DVQuery.queryId
    }

    # Return the query results
    Get-S1DvQueryResults -QueryID $DVQuery.queryId
}