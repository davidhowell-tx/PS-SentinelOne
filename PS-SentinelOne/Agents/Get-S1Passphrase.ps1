function Get-S1Passphrase {
    [CmdletBinding(DefaultParameterSetName="All")]
    Param(
        [Parameter(Mandatory=$False)]
        [String]
        $AgentName,

        [Parameter(Mandatory=$False)]
        [String[]]
        $AgentID
    )
    Process {
        # Log the function and parameters being executed
        $InitializationLog = $MyInvocation.MyCommand.Name
        $MyInvocation.BoundParameters.GetEnumerator() | ForEach-Object { $InitializationLog = $InitializationLog + " -$($_.Key) $($_.Value)"}
        Write-Log -Message $InitializationLog -Level Informational
        
        $Method = "Get"
        $URI = "/web/api/v2.1/agents/passphrases"
        $Parameters = @{}
        if ($Name) { $Parameters.Add("computerName__like",$AgentName) }
        if ($AgentID) { $Parameters.Add("ids", ($AgentID -join ",") ) }
        $Response = Invoke-S1Query -URI $URI -Method $Method -Parameters $Parameters -Recurse
        Write-Output $Response.data
    }
}