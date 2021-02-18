function Get-S1DvQueryResults {
    [CmdletBinding(DefaultParameterSetName="Default")]
    Param(
        [Parameter(Mandatory=$True)]
        [String]
        $QueryID,

        [Parameter(Mandatory=$True,ParameterSetName="CountOnly")]
        [Switch]
        $CountOnly
    )

    # Log the function and parameters being executed
    $InitializationLog = $MyInvocation.MyCommand.Name
    $MyInvocation.BoundParameters.GetEnumerator() | ForEach-Object { $InitializationLog = $InitializationLog + " -$($_.Key) $($_.Value)"}
    Write-Log -Message $InitializationLog -Level Informational

    $Limit = 100
    $URI = "/web/api/v2.1/dv/events"
    $Parameters = @{}
    $Parameters.Add("queryId", $QueryID)
    $Parameters.Add("limit", $Limit)
    $Method = "GET"

    if ($PSCmdlet.ParameterSetName -eq "CountOnly") {
        $Response = Invoke-S1Query -URI $URI -Method $Method -Parameters $Parameters
        return $Response.pagination.totalItems
    }

    $Response = Invoke-S1Query -URI $URI -Method $Method -Parameters $Parameters -Recurse
    return $Response.data
}