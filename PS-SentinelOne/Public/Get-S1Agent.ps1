function Get-S1Agent {
    <#
    .SYNOPSIS
        Retrieves information related to SentinelOne agents 
    
    .PARAMETER Name
        Filter agents by name
    
    .PARAMETER AgentID
        Filter applications by agent ID
    #>
    [CmdletBinding(DefaultParameterSetName="All")]
    Param(
        [Parameter(Mandatory=$False)]
        [String]
        $Name,

        [Parameter(Mandatory=$False)]
        [ValidateSet("none", "started", "aborted", "finished")]
        [String[]]
        $ScanStatus,

        [Parameter(Mandatory=$False)]
        [ValidateSet("unknown", "desktop", "laptop", "server")]
        [String[]]
        $MachineType,

        [Parameter(Mandatory=$False)]
        [ValidateSet("windows", "windows_legacy", "linux", "macos")]
        [String[]]
        $OSType,

        [Parameter(Mandatory=$False)]
        [ValidateSet("detect", "protect")]
        [String]
        $MitigationMode,

        [Parameter(Mandatory=$False)]
        [ValidateSet("true", "false")]
        [String]
        $Infected,

        # [Parameter(Mandatory=$False)]
        # [ValidateSet("true", "false")]
        # [String]
        # $ThreatResolved,

        [Parameter(Mandatory=$False)]
        [ValidateSet("patch_required", "up_to_date", "not_applicable")]
        [String[]]
        $AppVulnerabilityStatus,

        [Parameter(Mandatory=$False)]
        [ValidateSet("true", "false")]
        [String]
        $IsPendingUninstall,

        [Parameter(Mandatory=$False)]
        [ValidateSet("true", "false")]
        [String]
        $IsUninstalled,

        [Parameter(Mandatory=$False)]
        [ValidateSet("true", "false")]
        [String]
        $IsDecommissioned,

        [Parameter(Mandatory=$False)]
        [String[]]
        $ADQuery,

        [Parameter(Mandatory=$False)]
        [String[]]
        $Domain,

        [Parameter(Mandatory=$False)]
        [String[]]
        $LocalIP,

        [Parameter(Mandatory=$False)]
        [String[]]
        $AgentID,

        [Parameter(Mandatory=$False)]
        [String[]]
        $GroupID,

        [Parameter(Mandatory=$False)]
        [String[]]
        $SiteID,

        [Parameter(Mandatory=$False)]
        [String[]]
        $AccountID
    )
    Process {
        # Log the function and parameters being executed
        $InitializationLog = $MyInvocation.MyCommand.Name
        $MyInvocation.BoundParameters.GetEnumerator() | ForEach-Object { $InitializationLog = $InitializationLog + " -$($_.Key) $($_.Value)"}
        Write-Log -Message $InitializationLog -Level Informational
        
        $URI = "/web/api/v2.1/agents"
        $Parameters = @{}
        if ($Name) { $Parameters.Add("computerName__contains",$Name) }
        if ($ScanStatus) { $Parameters.Add("scanStatuses", ($ScanStatus -join ",") ) }
        if ($MachineType) { $Parameters.Add("machineTypes", ($MachineType -join ",") ) }
        if ($OSType) { $Parameters.Add("osTypes", ($OSType -join ",") ) }
        if ($MitigationMode) { $Parameters.Add("mitigationMode", $MitigationMode) }
        if ($Infected) { $Parameters.Add("infected", $Infected ) }
        # if ($ThreatResolved) { $Parameters.Add("threatResolved", $ThreatResolved) }
        if ($AppVulnerabilityStatus) { $Parameters.Add("appsVulnerabilityStatuses", ($AppVulnerabilityStatus -join ",") ) }
        if ($IsPendingUninstall) { $Parameters.Add("isPendingUninstall", $IsPendingUninstall) }
        if ($IsUninstalled) { $Parameters.Add("isUninstalled", $IsUninstalled) }
        if ($IsDecommissioned) { $Parameters.Add("isDecommissioned", $IsDecommissioned) }
        if ($ADQuery) { $Parameters.Add("adQuery__contains", ($ADQuery -join ",") ) }
        if ($Domain) { $Parameters.Add("domains", ($Domain -join ",") ) }
        if ($LocalIP) { $Parameters.Add("networkInterfaceInet__contains", ($LocalIP -join "," ) ) }
        if ($AgentID) { $Parameters.Add("ids", ($AgentID -join ",") ) }
        if ($GroupID) { $Parameters.Add("groupIds", ($GroupID -join ",") ) }
        if ($SiteID) { $Parameters.Add("siteIds", ($SiteID -join ",") ) }
        if ($AccountID) { $Parameters.Add("accountIds", ($AccountID -join ",") ) }
        $Response = Invoke-S1Query -URI $URI -Method GET -Parameters $Parameters -Recurse
        Write-Output $Response.data
    }
}