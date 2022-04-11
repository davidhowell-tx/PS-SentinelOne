function New-S1DvQuery {
    [CmdletBinding()]
    Param(
        [Parameter()]
        [ValidateSet("events","processes")]
        [String]
        $QueryType="events",

        [Parameter(Mandatory=$True)]
        $Query,

        [Parameter(Mandatory=$False)]
        [ValidateSet(1, 10, 100, 1000, 2000, 5000, 10000, 20000)]
        $Limit = 1000,

        [Parameter(Mandatory=$True,ParameterSetName="TimeFrame")]
        [ValidateSet("Last Hour","Last 24 Hours","Last 48 Hours","Last 7 Days","Last 14 Days","Last 30 Days","Last 2 Months","Last 3 Months")]
        [String]
        $TimeFrame,

        [Parameter(Mandatory=$True,ParameterSetName="CustomTime")]
        [DateTime]
        $ToDate,

        [Parameter(Mandatory=$True,ParameterSetName="CustomTime")]
        [DateTime]
        $FromDate,

        [Parameter(Mandatory=$False)]
        [String[]]
        $GroupID,

        [Parameter(Mandatory=$False)]
        [String[]]
        $SiteID,

        [Parameter(Mandatory=$False)]
        [String[]]
        $AccountID
    )

    # Log the function and parameters being executed
    $InitializationLog = $MyInvocation.MyCommand.Name
    $MyInvocation.BoundParameters.GetEnumerator() | ForEach-Object { $InitializationLog = $InitializationLog + " -$($_.Key) $($_.Value)"}
    Write-Log -Message $InitializationLog -Level Informational

    if ($PSCmdlet.ParameterSetName -eq "TimeFrame") {
        $ToDate = [DateTime]::Now
        switch ($TimeFrame) {
            "Last Hour" { $FromDate = $ToDate.AddHours(-1) }
            "Last 24 Hours" { $FromDate = $ToDate.AddDays(-1) }
            "Last 48 Hours" { $FromDate = $ToDate.AddDays(-2) }
            "Last 7 Days" { $FromDate = $ToDate.AddDays(-7) }
            "Last 14 Days" { $FromDate = $ToDate.AddDays(-14) }
            "Last 30 Days" { $FromDate = $ToDate.AddDays(-30) }
            "Last 2 Months" { $FromDate = $ToDate.AddMonths(-2) }
            "Last 3 Months" { $FromDate = $ToDate.AddMonths(-3) }
        }
    }
    $To = Convert-S1Time -Value $ToDate
    $From = Convert-S1Time -Value $FromDate

    $URI = "/web/api/v2.1/dv/init-query"
    $Method = "POST"
    $Body = @{
        fromDate = $From
        toDate = $To
        limit = $Limit
        query = $Query
        queryType = @( $QueryType )
    }
    if ($GroupID) { $Body.Add("groupdIds", @($GroupId -join ",") )}
    if ($SiteID) { $Body.Add("siteIds", @($SiteID -join ",") )}
    if ($AccountID) { $Body.Add("accountIds", @($AccountID -join ",") )}

    $Response = Invoke-S1Query -URI $URI -Method $Method -Body ($Body | ConvertTo-Json) -ContentType "application/json"

    Write-Output $Response.data
}