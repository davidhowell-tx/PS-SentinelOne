function Get-S1Application {
    <#
    .SYNOPSIS
        Gets information related to applications on SentinelOne agents
    
    .PARAMETER AgentID
        Filter applications by agent ID
    #>
    [CmdletBinding(DefaultParameterSetName="All")]
    Param(
        [Parameter(Mandatory=$True,ParameterSetName="Agent")]
        [String[]]
        $AgentID,

        [Parameter(Mandatory=$False,ParameterSetName="All")]
        [String[]]
        $ApplicationName,

        [Parameter(Mandatory=$False,ParameterSetName="All")]
        [String[]]
        $ApplicationID,

        [Parameter(Mandatory=$False,ParameterSetName="All")]
        [String[]]
        $GroupID,

        [Parameter(Mandatory=$False,ParameterSetName="All")]
        [String[]]
        $SiteID,

        [Parameter(Mandatory=$False,ParameterSetName="All")]
        [String[]]
        $AccountID,

        [Parameter(Mandatory=$False,ParameterSetName="All")]
        [ValidateSet("none","low","medium","high","critical")]
        [String[]]
        $RiskLevel,

        [Parameter(Mandatory=$False,ParameterSetName="All")]
        [ValidateSet("app","kb","patch","chromeExtension","edgeExtension","firefoxExtension","safariExtension")]
        [String[]]
        $ApplicationType,

        [Parameter(Mandatory=$False,ParameterSetName="All")]
        [ValidateSet("windows","windows_legacy","linux","macos")]
        [String[]]
        $OS,

        [Parameter(Mandatory=$False,ParameterSetName="All")]
        [ValidateSet("unknown","desktop","laptop","server")]
        [String[]]
        $MachineType,

        [Parameter(Mandatory=$False,ParameterSetName="All")]
        [ValidateSet("true","false")]
        [String]
        $Decommissioned
    )
    Process {
        # Log the function and parameters being executed
        $InitializationLog = $MyInvocation.MyCommand.Name
        $MyInvocation.BoundParameters.GetEnumerator() | ForEach-Object { $InitializationLog = $InitializationLog + " -$($_.Key) $($_.Value)"}
        Write-Log -Message $InitializationLog -Level Informational

        switch ($PSCmdlet.ParameterSetName) {
            "Agent" {
                $URI = "/web/api/v2.0/agents/applications"
                $Parameters = @{ "ids" = ($AgentID -join ",") }

                $Response = Invoke-S1Query -URI $URI -Method Get -Parameters $Parameters
                Write-Output $Response.data
            }
            "All" {
                $URI = "/web/api/v2.0/installed-applications"
                $Parameters = @{}
                if ($ApplicationName) { $Parameters.Add("name__contains", ($ApplicationName -join ",") ) }
                if ($ApplicationID) { $Parameters.Add("ids", ($ApplicationID -join ",") ) }
                if ($GroupID) { $Parameters.Add("groupIds", ($GroupID -join ",") ) }
                if ($SiteID) { $Parameters.Add("siteIds", ($SiteID -join ",") ) }
                if ($AccountID) { $Parameters.Add("accountIds", ($AccountID -join ",") ) }
                if ($RiskLevel) { $Parameters.Add("riskLevels", ($RiskLevel -join ",") ) }
                if ($ApplicationType) { $Parameters.Add("types", ($ApplicationType -join ",") ) }
                if ($OS) { $Parameters.Add("osTypes", ($OS -join ",") ) }
                if ($MachineType) { $Parameters.Add("agentMachineTypes", ($MachineType -join ",") ) }
                if ($Decommissioned) { $Parameters.Add("agentIsDecommissioned", $Decommissioned) }
                $Parameters.Add("skipCount", "true")

                $Response = Invoke-S1Query -URI $URI -Method Get -Parameters $Parameters -Recurse
                Write-Output $Response.data
            }
        }
    }
}