function Get-S1ModuleConfiguration {
    <#
    .SYNOPSIS
        Retrieves the current configuration values for the PS-SentinelOne Module

    .PARAMETER Persisted
        Retrieve the configuration persisted to disk
    
    .PARAMETER Cache
        Instructs this function to cache the configuration settings in a variable accesible to subsequent requests so that saved configuration does not need to be retrieved for every request
    #>
    [CmdletBinding(DefaultParameterSetName="Cached")]
    Param(
        [Parameter(Mandatory=$True,ParameterSetName="Persisted")]
        [Switch]
        $Persisted,

        [Parameter(Mandatory=$False,ParameterSetName="Persisted")]
        [Switch]
        $Cache
    )
    # Log the command executed by the user
    $InitializationLog = $MyInvocation.MyCommand.Name
    $MyInvocation.BoundParameters.GetEnumerator() | ForEach-Object { $InitializationLog = $InitializationLog + " -$($_.Key) $($_.Value)"}
    Write-Log -Message $InitializationLog -Level Verbose

    if ($Persisted) {
        $Configuration = Read-S1ModuleConfiguration -Path $Script:PSSentinelOne.ConfPath

        if ($Cache) {
            Write-Log -Message "Caching configuration settings for future queries." -Level Verbose
            if ($Configuration.URI -and -not $Script:PSSentinelOne.ManagementURL) {
                $Script:PSSentinelOne.Add("ManagementURL", $Configuration.URI)
            }

            if ($Configuration.ApiToken -and -not $Script:PSSentinelOne.ApiToken) {
                $Script:PSSentinelOne.Add("ApiToken", $Configuration.ApiToken)
            }

            if ($Configuration.TemporaryToken -and -not $Script:PSSentinelOne.ApiToken) {
                $Script:PSSentinelOne.Add("TemporaryToken", $Configuration.TemporaryToken)
            }
            return
        }

        return $Configuration
    } else {
        return $Script:PSSentinelOne
    }
}