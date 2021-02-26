    function Get-S1Threat {
        <#
        .SYNOPSIS
            Retrieve Threats from SentinelOne
        #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$False)]
        [ValidateSet(
            "unresolved",
            "in_progress",
            "resolved"
        )]
        [String]
        $IncidentStatus,

        [Parameter(Mandatory=$False)]
        [ValidateSet(
            "not_mitigated",
            "mitigated",
            "marked_as_benign"
        )]
        [String]
        $MitigationStatus,

        [Parameter(Mandatory=$False)]
        [ValidateSet("true","false")]
        [String]
        $MitigatedPreEmptively,

        [Parameter(Mandatory=$False)]
        [ValidateSet("true","false")]
        [String]
        $ActionFailed,

        [Parameter(Mandatory=$False)]
        [ValidateSet("true","false")]
        [String]
        $ActionPending,

        [Parameter(Mandatory=$False)]
        [ValidateSet(
            "reputation",
            "sentinelone_cloud",
            "user_blacklist",
            "pre_execution",
            "pre_execution_suspicious",
            "executables",
            "data_files",
            "exploits",
            "penetration",
            "pup",
            "lateral_movement",
            "remote_shell",
            "manual"
        )]
        [String[]]
        $Engine,

        [Parameter(Mandatory=$False)]
        [ValidateSet(
            "agent_policy",
            "full_disk_scan",
            "sentinelctl",
            "dv_command",
            "console_api"
        )]
        [String[]]
        $InitiatedBy,

        [Parameter(Mandatory=$False)]
        [ValidateSet(
            "malicious",
            "suspicious",
            "n/a"
        )]
        [String[]]
        $ConfidenceLevel,

        [Parameter(Mandatory=$False)]
        [ValidateSet(
            "undefined",
            "true_positive",
            "false_positive",
            "suspicious"
        )]
        [String[]]
        $AnalystVerdict,

        [Parameter(Mandatory=$False)]
        [ValidateSet(
            "Cloud",
            "Behavioral",
            "Static",
            "Engine"
        )]
        [String[]]
        $ClassificationSource,

        [Parameter(Mandatory=$False)]
        [String]
        $FilePath,

        [Parameter(Mandatory=$False)]
        [String[]]
        $ContentHash,

        [Parameter(Mandatory=$False)]
        [ValidateSet("windows", "windows_legacy", "linux", "macos")]
        [String[]]
        $OSType,

        [Parameter(Mandatory=$False)]
        [ValidateSet("unknown", "desktop", "laptop", "server", "kubernetes node")]
        [String[]]
        $MachineType,
        
        [Parameter(Mandatory=$False)]
        [String]
        $AgentName,

        [Parameter(Mandatory=$False)]
        [String[]]
        $ThreatID,

        [Parameter(Mandatory=$False)]
        [String[]]
        $CollectionID,

        [Parameter(Mandatory=$False)]
        [String]
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

        <#
            -DisplayName (displayName) string
            -Query (query) string
            -ThreatDetails (threatDetails__contains) array of strings
            -CommandlineArgument (commandLineArguments__contains) array of strings

            -Classification "Malware"
            -InitiatedBy "Full Disk Scan", "agent Policy"
            -OS "Windows", "macOS", "Linux", "Windows Legacy"
            -OSVersion "Windows 10 Enterprise"
 
            -ReportedTime "Last Hour", "Last 24 Hours", "Last 7 Days", "Last 30 Days", "Last Month", "Last 2 Months", "Last 3 Months", "Last Year"
        #>

        <#
            Created
                createdAt__gt
                createdAt__gte
                createdAt__lt
                createdAt__lte
                    format 2018-02-27T04:49:26.257525Z
            Updated
                updatedAt__gt
                updatedAt__gte
                updatedAt__lt
                updatedAt__lte

            threatDetails__contains
            -ClassificationSource (classificationSources) "Cloud", "Behavioral", "Static", "Engine"
            osNames
            updatedAt__lte
            noteExists
            detectionAgentVersion__contains
            engines
            originatedProcess__contains
            agentMachineTypes
        #>
        $URI = "/web/api/v2.1/threats"
        $Parameters = @{}
        if ($IncidentStatus) { $Parameters.Add("incidentStatuses", $IncidentStatus) }
        if ($MitigationStatus) { $Parameters.Add("mitigationStatuses", $MitigationStatus) }
        if ($MitigatedPreEmptively) { $Parameters.Add("mitigatedPreemptively", $MitigatedPreEmptively) }
        if ($ActionFailed) { $Parameters.Add("failedActions", $ActionFailed) }
        if ($ActionPending) { $Parameters.Add("pendingActions", $ActionPending) }
        if ($Engine) { $Parameters.Add("engines", $Engine) }
        if ($InitiatedBy) { $Parameters.Add("initiatedBy", ($InitiatedBy -join ",")) }
        if ($ConfidenceLevel) { $Parameters.Add("confidenceLevels", ($ConfidenceLevel -join ",")) }
        if ($AnalystVerdict) { $Parameters.Add("analystVerdicts", ($AnalystVerdict -join ",")) }
        if ($ClassificationSource) { $Parameters.Add("classificationSources", ($ClassificationSource -join ",")) }

        if ($FilePath) { $Parameters.Add("filePath__contains", ($FilePath -join ",") ) }
        if ($ContentHash) { $Parameters.Add("contentHashes__contains", ($ContentHash -join ",") ) }

        if ($OSType) { $Parameters.Add("osTypes", ($OSType -join ",") ) }
        if ($AgentName) { $Parameters.Add("computerName__contains", $AgentName) }

        if ($ThreatID) { $Parameters.Add("ids", ($ThreatID -join ",") ) }
        if ($CollectionID) { $Parameters.Add("collectionIds", ($CollectionID -join ",") ) }
        if ($AgentID) { $Parameters.Add("agentId", $AgentID) }
        if ($GroupID) { $Parameters.Add("groupIds", ($GroupID -join ",") ) }
        if ($SiteID) { $Parameters.Add("siteIds", ($SiteID -join ",") ) }
        if ($AccountID) { $Parameters.Add("accountIds", ($AccountID -join ",") ) }
        $Response = Invoke-S1Query -URI $URI -Method GET -Parameters $Parameters -Recurse
        Write-Output $Response.data
    }
    End{}
}