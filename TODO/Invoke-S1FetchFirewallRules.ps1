function Invoke-S1FetchFirewallRules {
    <#
    .SYNOPSIS
        Sends a "fetch firewall rules" command to agents matching supplied filters
    
    .DESCRIPTION
        Sends a "fetch firewall rules" command to agents matching supplied filters.
        Note: Firewall control feature must be enabled

    .PARAMETER AgentID
        The Agent ID to send the command to
        
    .PARAMETER FilePath
        An array of file paths to be fetched from the agent

    .PARAMETER Password
        The password to use to protect the zip file
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$True)]
        [String]
        $AgentID,

        [Parameter(Mandatory=$True)]
        [String[]]
        $FilePath,

        [Parameter(Mandatory=$True)]
        [String]
        $Password
    )
    Process {
        # Log the function and parameters being executed
        $InitializationLog = $MyInvocation.MyCommand.Name
        $MyInvocation.BoundParameters.GetEnumerator() | ForEach-Object { $InitializationLog = $InitializationLog + " -$($_.Key) $($_.Value)"}
        Write-Log -Message $InitializationLog -Level Informational
        
        $URI = "/web/api/v2.0/agents/$AgentID/actions/fetch-files"
        $Method = "Post"

        $Body = @{
            data = @{
                password = $Password
                files = $FilePath
            }
        }
        $BodyJson = $Body | ConvertTo-Json
        $Response = Invoke-S1Query -URI $URI -Method $Method -Body $BodyJson -ContentType "application/json"
        Write-Output $Response.data
    }
}