function Get-S1System {
    <#
    .SYNOPSIS
        Get various information from SentinelOne's system APIs
    #>
    [CmdletBinding(DefaultParameterSetName="Info")]
    Param(
        # Query the System Info API
        [Parameter(Mandatory=$True,ParameterSetName="Info")]
        [Switch]
        $Info,

        # This one may only be available to SentinelOne support?
        # Query the System Config API
        #[Parameter(Mandatory=$True,ParameterSetName="Config")]
        #[Switch]
        #$Config,

        # Query the System Status API
        [Parameter(Mandatory=$True,ParameterSetName="Status")]
        [Switch]
        $Status,

        # Query the Cache Status API
        [Parameter(Mandatory=$True,ParameterSetName="CacheStatus")]
        [Switch]
        $CacheStatus,

        # Query the Database Status API
        [Parameter(Mandatory=$True,ParameterSetName="DatabaseStatus")]
        [Switch]
        $DatabaseStatus
    )
    Process {
        # Log the function and parameters being executed
        $InitializationLog = $MyInvocation.MyCommand.Name
        $MyInvocation.BoundParameters.GetEnumerator() | ForEach-Object { $InitializationLog = $InitializationLog + " -$($_.Key) $($_.Value)"}
        Write-Log -Message $InitializationLog -Level Verbose

        switch ($PSCmdlet.ParameterSetName) {
            "Info" { $URI = "/web/api/v2.1/system/info" }
            #"Config" { $URI = "/web/api/v2.1/system/configuration" }
            "Status" { $URI = "/web/api/v2.1/system/status" }
            "CacheStatus" { $URI = "/web/api/v2.1/system/status/cache" }
            "DatabaseStatus" { $URI = "/web/api/v2.1/system/status/db" }
        }
        $Request = @{
            URI = $URI
            Method = "Get"
        }
        $Response = Invoke-S1Query @Request
        Write-Output $Response.data
    }
  }