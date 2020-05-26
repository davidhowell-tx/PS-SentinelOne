function Set-S1Policy {
    <#
    .SYNOPSIS
        Modify policy settings in SentinelOne
    
    .PARAMETER GroupID
        Modify policy settings by Group ID
    
    .PARAMETER SiteID
        Modify policy settings by Site ID

    .PARAMETER AccountID
        Modify policy settings by Account ID
    
    .PARAMETER Policy
        The new policy object to set
    
    .PARAMETER RevertPolicy
        Reverts policy settings to inherit from parent
    
    .EXAMPLE
        $Policy = Get-S1Policy -GroupID <id>
        $Policy.mitigationMode = "detect"
        Set-S1Policy -GroupID <id> -NewPolicy $Policy
    
    .EXAMPLE
        Set-S1Policy -GroupID <id> -RevertPolicy
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$True,ParameterSetName="SetGroup")]
        [Parameter(Mandatory=$True,ParameterSetName="RevertGroup")]
        [String]
        $GroupID,

        [Parameter(Mandatory=$True,ParameterSetName="SetSite")]
        [Parameter(Mandatory=$True,ParameterSetName="RevertSite")]
        [String]
        $SiteID,

        [Parameter(Mandatory=$True,ParameterSetName="SetAccount")]
        [Parameter(Mandatory=$True,ParameterSetName="RevertAccount")]
        [String]
        $AccountID,

        [Parameter(Mandatory=$True,ParameterSetName="SetGroup")]
        [Parameter(Mandatory=$True,ParameterSetName="SetSite")]
        [Parameter(Mandatory=$True,ParameterSetName="SetAccount")]
        $NewPolicy,

        [Parameter(Mandatory=$True,ParameterSetName="RevertGroup")]
        [Parameter(Mandatory=$True,ParameterSetName="RevertSite")]
        [Parameter(Mandatory=$True,ParameterSetName="RevertAccount")]
        [Switch]
        $RevertPolicy
    )
    Process {
        # Log the function and parameters being executed
        $InitializationLog = $MyInvocation.MyCommand.Name
        $MyInvocation.BoundParameters.GetEnumerator() | ForEach-Object { $InitializationLog = $InitializationLog + " -$($_.Key) $($_.Value)"}
        Write-Log -Message $InitializationLog -Level Informational

        switch ($PSCmdlet.ParameterSetName) {
            "RevertGroup" {
                $URI = "/web/api/v2.0/groups/$GroupID/revert-policy"
                $Body = @{ "data" = @{ "id" = $GroupID } }
                $Method = "Put"
            }
            "RevertSite" {
                $URI = "/web/api/v2.0/sites/$SiteID/revert-policy"
                $Body = @{ "data" = @{ "id" = $SiteID } }
                $Method = "Put"
            }
            "RevertAccount" {
                $URI = "/web/api/v2.0/accounts/$AccountID/revert-policy"
                $Body = @{ "data" = @{ "id" = $AccountID } }
                $Method = "Put"
            }
            "SetGroup" {
                $URI = "/web/api/v2.0/private/policy"
                $Body = @{
                    "data" = $NewPolicy
                    "filter" = @{ "groupIds" = $GroupID }
                }
                $Method = "Post"
            }
            "SetSite" {
                $URI = "/web/api/v2.0/private/policy"
                $Body = @{
                    "data" = $NewPolicy
                    "filter" = @{ "siteIds" = $SiteID}
                }
                $Method = "Post"
            }
            "SetAccount" {
                $URI = "/web/api/v2.0/private/policy"
                $Body = @{
                    "data" = $NewPolicy
                    "filter" = @{ "accountIds" = $AccountID }
                }
                $Method = "Post"
            }
        }
        
        $Response = Invoke-S1Query -URI $URI -Method $Method -Body ($Body | ConvertTo-Json) -ContentType "application/json"
        Write-Output $Response.data
    }
}