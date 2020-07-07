function Get-S1DVQueryStatus {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$True)]
        [String]
        $QueryID
    )

    # Log the function and parameters being executed
    $InitializationLog = $MyInvocation.MyCommand.Name
    $MyInvocation.BoundParameters.GetEnumerator() | ForEach-Object { $InitializationLog = $InitializationLog + " -$($_.Key) $($_.Value)"}
    Write-Log -Message $InitializationLog -Level Informational

    $URI = "/web/api/v2.1/dv/query-status"
    $Parameters = @{}
    $Parameters.Add("queryId", $QueryID)
    $Method = "GET"

    $Response = Invoke-S1Query -URI $URI -Method $Method -Parameters $Parameters

    Write-Output $Response.data
}