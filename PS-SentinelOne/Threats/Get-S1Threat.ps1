    function Get-S1Threat {
        <#
        .SYNOPSIS
            Retrieve Threats from SentinelOne
        #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$False)]
        [ValidateSet("active", "mitigated", "blocked", "suspicious", "pending", "suspicious_resolved")]
        [String]
        $Status,

        [Parameter(Mandatory=$False)]
        [ValidateSet("true", "false")]
        [String]
        $Resolved,

        [Parameter(Mandatory=$False)]
        [ValidateSet("reputation", "pre_execution", "pre_execution_suspicious", "executables", "data_files", "exploits", "penetration", "pup", "lateral_movement", "remote_shell", "manual")]
        [String[]]
        $Engine,

        [Parameter(Mandatory=$False)]
        [String]
        $FilePath,

        [Parameter(Mandatory=$False)]
        [String[]]
        $FileName,

        [Parameter(Mandatory=$False)]
        [String[]]
        $SHA1,

        [Parameter(Mandatory=$False)]
        [String[]]
        $ThreatID,

        [Parameter(Mandatory=$False)]
        [ValidateSet("windows", "windows_legacy", "linux", "macos")]
        [String[]]
        $OSType,

        [Parameter(Mandatory=$False)]
        [String]
        $AgentName,

        [Parameter(Mandatory=$False)]
        [String]
        $AgentID,

        [Parameter(Mandatory=$False)]
        [String[]]
        $AgentUUID,

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

        $URI = "/web/api/v2.0/threats"
        $Parameters = @{}
        if ($Status) { $Parameters.Add("status", $Status) }
        if ($Resolved) { $Parameters.Add("resolved", $Resolved) }
        if ($Engine) { $Parameters.Add("engines", $Engine) }
        if ($FilePath) { $Parameters.Add("filePath__contains", ($FilePath -join ",") ) }
        if ($FileName) { $Parameters.Add("fileDisplayName__contains", ($FileName -join ",") ) }
        if ($SHA1) { $Parameters.Add("contentHashes__contains", ($SHA1 -join ",") ) }
        if ($ThreatID) { $Parameters.Add("ids", ($ThreatID -join ",") ) }
        if ($OSType) { $Parameters.Add("osTypes", ($OSType -join ",") ) }
        if ($AgentName) { $Parameters.Add("computerName__contains", $AgentName) }
        if ($AgentUUID) { $Parameters.Add("uuid__contains", ($AgentUUID -join ",") ) }
        if ($AgentID) { $Parameters.Add("agentId", $AgentID) }
        if ($GroupID) { $Parameters.Add("groupIds", ($GroupID -join ",") ) }
        if ($SiteID) { $Parameters.Add("siteIds", ($SiteID -join ",") ) }
        if ($AccountID) { $Parameters.Add("accountIds", ($AccountID -join ",") ) }
        $Response = Invoke-S1Query -URI $URI -Method GET -Parameters $Parameters -Recurse
        Write-Output $Response.data
    }
    End{}
}