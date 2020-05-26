function Get-S1Policy {
    <#
    .SYNOPSIS
        Gets information related to policies in SentinelOne
    
    .PARAMETER GroupID
        Get policy settings by Group ID
    
    .PARAMETER SiteID
        Get policy settings by Site ID

    .PARAMETER AccountID
        Get policy settings by Account ID
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$True,ParameterSetName="GroupID")]
        [String[]]
        $GroupID,

        [Parameter(Mandatory=$True,ParameterSetName="SiteID")]
        [String[]]
        $SiteID,

        [Parameter(Mandatory=$True,ParameterSetName="AccountID")]
        [String[]]
        $AccountID
    )
    Process {
        # Log the function and parameters being executed
        $InitializationLog = $MyInvocation.MyCommand.Name
        $MyInvocation.BoundParameters.GetEnumerator() | ForEach-Object { $InitializationLog = $InitializationLog + " -$($_.Key) $($_.Value)"}
        Write-Log -Message $InitializationLog -Level Informational

        switch ($PSCmdlet.ParameterSetName) {
            "GroupID" {
                $URI = "/web/api/v2.0/groups/$GroupID/policy"
            }
            "SiteID" {
                $URI = "/web/api/v2.0/sites/$SiteID/policy"
            }
            "AccountID" {
                $URI = "/web/api/v2.0/accounts/$AccountID/policy"
            }
        }
        
        $Response = Invoke-S1Query -URI $URI -Method Get
        Write-Output $Response.data
    }
}