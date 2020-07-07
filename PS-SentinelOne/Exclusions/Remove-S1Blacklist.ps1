function Remove-S1Blacklist {
    <#
    .SYNOPSIS
        Removes a blacklist entry from SentinelOne 
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$True)]
        [String[]]
        $BlacklistID
    )
    Process {
        # Log the function and parameters being executed
        $InitializationLog = $MyInvocation.MyCommand.Name
        $MyInvocation.BoundParameters.GetEnumerator() | ForEach-Object { $InitializationLog = $InitializationLog + " -$($_.Key) $($_.Value)"}
        Write-Log -Message $InitializationLog -Level Informational

        $Body = @{
            data = @{
                type = "black_hash"
                ids = @($BlacklistID -join ",")
            }
        }
        
        $URI = "/web/api/v2.1/restrictions"
        $Response = Invoke-S1Query -URI $URI -Method DELETE -Body ($Body | ConvertTo-Json) -ContentType "application/json"
        Write-Output $Response.data
    }
}