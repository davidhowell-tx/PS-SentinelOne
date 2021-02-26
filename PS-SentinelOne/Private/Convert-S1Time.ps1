function Convert-S1Time {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$True,ValueFromPipeline=$True)]
        [DateTime]
        $Value
    )
    #$Epoch = [DateTime]::new(1970,1,1,0,0,0,([DateTimeKind]::Utc))
    #return [int64]($Value.ToUniversalTime() - $Epoch).TotalMilliseconds

    return $Value.ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ss.ffffffZ")
}