function New-S1Exclusion {
    <#
    .SYNOPSIS
        Creates a new exclusion entry in SentinelOne
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$True,ParameterSetName="Path")]
        [String]
        $Path,

        [Parameter(Mandatory=$False,ParameterSetName="Path")]
        [Switch]
        $IncludeSubfolders,

        [Parameter(Mandatory=$True,ParameterSetName="Path")]
        [ValidateSet(
            "suppress",
            "suppress_dfi_only",
            "suppress_dynamic_only",
            "disable_in_process_monitor",
            "disable_in_process_monitor_deep",
            "disable_all_monitors",
            "disable_all_monitors_deep"
        )]
        [String]
        $ExclusionType,

        [Parameter(Mandatory=$True,ParameterSetName="Hash")]
        [String]
        $Hash,

        [Parameter(Mandatory=$True,ParameterSetName="Certificate")]
        [String]
        $Certificate,

        [Parameter(Mandatory=$True,ParameterSetName="Browser")]
        [ValidateSet("chrome", "firefox", "edge", "ie")]
        [String]
        $Browser,

        [Parameter(Mandatory=$True,ParameterSetName="FileType")]
        [String]
        $FileType,

        [Parameter(Mandatory=$True)]
        [ValidateSet("windows", "macos", "linux", "windows_legacy")]
        [String]
        $OSType,

        [Parameter(Mandatory=$False)]
        [String]
        $Description,

        [Parameter(Mandatory=$True,ParameterSetName="GroupLevel")]
        [String]
        $GroupID,

        [Parameter(Mandatory=$True,ParameterSetName="SiteLevel")]
        [String]
        $SiteID,

        [Parameter(Mandatory=$True,ParameterSetName="AccountLevel")]
        [String]
        $AccountID
    )
    Process {
        # Log the function and parameters being executed
        $InitializationLog = $MyInvocation.MyCommand.Name
        $MyInvocation.BoundParameters.GetEnumerator() | ForEach-Object { $InitializationLog = $InitializationLog + " -$($_.Key) $($_.Value)"}
        Write-Log -Message $InitializationLog -Level Informational

        $Body = @{
            data = @{
                osType = $OSType
                description = $Description
            }
            filter = @{}
        }

        if ($Path) {
            if (-not(Test-Path $Path -IsValid)) {
                Write-Error "Path is not valid"
                return
            }
            $Body.data.Add("type", "path")
            $Body.data.Add("includeSubfolders", "false")
            $Body.data.Add("inject","true")
            $Body.data.Add("value", $Path)

            if ($Path -match "^.+\\$") {
                $Body.data.Add("pathExclusionType", "folder")
                if ($IncludeSubfolders) {
                    $Body.data.Add("includeSubfolders", "true")
                }
            } else {
                $Body.data.Add("pathExclusionType", "file")
            }
        }
        if ($Certificate) {
            $Body.data.Add("type", "certificate")
            $Body.data.Add("value", $Certificate)
        }
        if ($Browser) {
            $Body.data.Add("type", "browser")
            $Body.data.Add("value", $Browser)
        }
        if ($FileType) {
            $Body.data.Add("type", "file_type")
            $Body.data.Add("value", $FileType)
        }
        if ($Hash) {
            $Body.data.Add("type", "white_hash")
            $Body.data.Add("value", $Hash)
        }
        

        if ($GroupID) { $Body.filter.Add("groupIds", @($GroupID -join ",")) }
        if ($SiteID) { $Body.filter.Add("siteIds", @($SiteID -join ",")) }
        if ($AccountID) { $Body.filter.Add("accountIds", @($AccountID -join ",")) }
        
        $URI = "/web/api/v2.1/restrictions"
        $Response = Invoke-S1Query -URI $URI -Method POST -Body ($Body | ConvertTo-Json) -ContentType "application/json"
        Write-Output $Response.data
    }
}