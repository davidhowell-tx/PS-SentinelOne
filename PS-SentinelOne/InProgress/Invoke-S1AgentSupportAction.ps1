function Invoke-S1AgentSupportAction {
    <#
    .SYNOPSIS
        Used to send various support commands to agents, such as protect, unprotect, revoke token, etc.
        Not currently exported

    .PARAMETER Action
        The type of action to take
    
    .PARAMETER AgentID
        The Agent ID to send the command to
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$True)]
        [ValidateSet(
            "Unprotect",
            "Protect"
        )]
        [String]
        $Action,

        [Parameter(Mandatory=$False)]
        [String[]]
        $AgentID
    )
    Process {
        # Log the function and parameters being executed
        $InitializationLog = $MyInvocation.MyCommand.Name
        $MyInvocation.BoundParameters.GetEnumerator() | ForEach-Object { $InitializationLog = $InitializationLog + " -$($_.Key) $($_.Value)"}
        Write-Log -Message $InitializationLog -Level Informational

        $Method = "Post"
        $Body = @{
            data = @{}
            filter = @{}
        }

        switch ($Action) {
            "Unprotect" {
                $URI = "/web/api/v2.0/private/agents/support-actions/unprotect"
            }
            "Protect" {
                $URI = "/web/api/v2.0/private/agents/support-actions/protect"
            }
        }
        
        if ($AgentID) { $Body.filter.Add("ids", ($AgentID -join ",") ) }
        
        $BodyJson = $Body | ConvertTo-Json
        $Response = Invoke-S1Query -URI $URI -Method $Method -Body $BodyJson -ContentType "application/json"
        Write-Output $Response.data
    }
}