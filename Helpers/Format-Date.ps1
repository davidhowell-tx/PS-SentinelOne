function Format-Date {
    <#
    .SYNOPSIS
        Used to format a DateTime object into the various formats used by the SentinelOne API
    
    .DESCRIPTION
        Used to format a DateTime object into the various formats used by the SentinelOne API
        Default format is yyyy-MM-ddTHH:mm:ss.ffffffZ, i.e. 2020-01-31T06:00:00.000000Z
    
    .PARAMETER UnixMS
        Used to change output to Unix Epoch time in Milliseconds
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$True)]
        [DateTime]
        $InputObject,

        [Switch]
        $UnixMS
    )

    # Log the function and parameters being executed
    $InitializationLog = $MyInvocation.MyCommand.Name
    $MyInvocation.BoundParameters.GetEnumerator() | ForEach-Object { $InitializationLog = $InitializationLog + " -$($_.Key) $($_.Value)"}
    Write-Log -Message $InitializationLog -Level Verbose

    $InputObjectUTC = $InputObject.ToUniversalTime()
    if ($UnixMS) {
        $UnixSource = (Get-Date "1/1/1970").ToUniversalTime()
        $UnixEpochTime = ($InputObjectUTC - $UnixSource).TotalMilliseconds
        Write-Output $UnixEpochTime
    } else {
        Write-Output $InputObjectUTC.ToString("yyyy-MM-ddTHH:mm:ss.ffffffZ")
    }
}