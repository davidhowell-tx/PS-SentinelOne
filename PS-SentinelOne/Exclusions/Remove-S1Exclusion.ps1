function Remove-S1Exclusion {
    <#
    .SYNOPSIS
        Removes an exclusion entry from SentinelOne 
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$True)]
        [String[]]
        $ExclusionID,

        [Parameter(Mandatory=$True)]
        [ValidateSet("path","white_hash","file_type","browser","certificate")]
        [String]
        $Type
    )
    Process {
        # Log the function and parameters being executed
        $InitializationLog = $MyInvocation.MyCommand.Name
        $MyInvocation.BoundParameters.GetEnumerator() | ForEach-Object { $InitializationLog = $InitializationLog + " -$($_.Key) $($_.Value)"}
        Write-Log -Message $InitializationLog -Level Informational

        $Body = @{
            data = @{
                type = $Type
                ids = @($ExclusionID -join ",")
            }
        }
        
        $URI = "/web/api/v2.1/exclusions"
        $Response = Invoke-S1Query -URI $URI -Method DELETE -Body ($Body | ConvertTo-Json) -ContentType "application/json"
        Write-Output $Response.data
    }
}