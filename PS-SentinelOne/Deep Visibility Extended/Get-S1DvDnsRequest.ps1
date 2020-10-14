function Get-S1DvDnsRequest {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$False)]
        [ValidateSet("Last Hour","Last 24 Hours","Today", "Last 48 Hours", "Last 7 Days", "Last 30 Days", "This Month", "Last 2 Months", "Last 3 Months")]
        [String]
        $TimeFrame = "Last Hour",

        [Parameter(Mandatory=$False)]
        [ValidateSet(1, 10, 100, 1000, 2000, 5000, 10000, 20000)]
        $Limit = 1000,

        [Parameter(Mandatory=$True)]
        [String[]]
        $SearchValue
    )
    # Define the Query String
    $Query = "DNSRequest In Contains Anycase (`"" + ($SearchValue -join "`",`"") + "`")"

    # Submit the Query
    $DVQuery = New-S1DVQuery -Query $Query -Limit $Limit -TimeFrame $TimeFrame

    # Check the status of the query every 5 seconds until it is complete
    $Status = Get-S1DVQueryStatus -QueryID $DVQuery.queryId
    while ($Status.responseState -ne "FINISHED") {
        Start-Sleep -Seconds 5
        $Status = Get-S1DVQueryStatus -QueryID $DVQuery.queryId
    }

    # Retrieve the results
    $DVEvents = Get-S1DVEvents -QueryID $DVQuery.queryId

    return $DVEvents
}