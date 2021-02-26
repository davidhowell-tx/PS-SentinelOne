function New-S1Group {
    <#
    .SYNOPSIS
        Create a new group in SentinelOne in the specified site. Currently only supports creating a group that inherits policy settings from the Site.
    
    .PARAMETER Name
        The name of the new site to be created

    .PARAMETER SiteID
        The site where the group should be created
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$True)]
        [String]
        $Name,

        [Parameter(Mandatory=$True)]
        [String]
        $SiteID
    )
    Process {
        # Log the function and parameters being executed
        $InitializationLog = $MyInvocation.MyCommand.Name
        $MyInvocation.BoundParameters.GetEnumerator() | ForEach-Object { $InitializationLog = $InitializationLog + " -$($_.Key) $($_.Value)"}
        Write-Log -Message $InitializationLog -Level Informational

        $Body = @{
            data = @{
            inherits = $true
            siteId = $SiteID
            name = $Name
            }
        }
        
        $URI = "/web/api/v2.1/groups"
        $Response = Invoke-S1Query -URI $URI -Method POST -Body ($Body | ConvertTo-Json) -ContentType "application/json"
        Write-Output $Response.data
    }
}