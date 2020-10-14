function Get-S1DvEvents {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$True)]
        [String]
        $QueryID,

        [Parameter(Mandatory=$False)]
        [ValidateRange(1,100)]
        [int]
        $Limit=100
    )

    # Log the function and parameters being executed
    $InitializationLog = $MyInvocation.MyCommand.Name
    $MyInvocation.BoundParameters.GetEnumerator() | ForEach-Object { $InitializationLog = $InitializationLog + " -$($_.Key) $($_.Value)"}
    Write-Log -Message $InitializationLog -Level Informational

    $URI = "/web/api/v2.1/dv/events"
    $Parameters = @{}
    $Parameters.Add("queryId", $QueryID)
    $Parameters.Add("limit", $Limit)
    $Method = "GET"

    $Response = Invoke-S1Query -URI $URI -Method $Method -Parameters $Parameters -Recurse

    Write-Output $Response.data
}