function New-S1Exclusion {
    <#
    .SYNOPSIS
        Creates a new exclusion entry in SentinelOne
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$True,ParameterSetName="AccountHash")]
        [Parameter(Mandatory=$True,ParameterSetName="SiteHash")]
        [Parameter(Mandatory=$True,ParameterSetName="GroupHash")]
        [String]
        $Hash,

        [Parameter(Mandatory=$True,ParameterSetName="AccountPath")]
        [Parameter(Mandatory=$True,ParameterSetName="SitePath")]
        [Parameter(Mandatory=$True,ParameterSetName="GroupPath")]
        [String]
        $Path,

        [Parameter(Mandatory=$False,ParameterSetName="AccountPath")]
        [Parameter(Mandatory=$False,ParameterSetName="SitePath")]
        [Parameter(Mandatory=$False,ParameterSetName="GroupPath")]
        [Switch]
        $IncludeSubfolders,

        [Parameter(Mandatory=$True,ParameterSetName="AccountPath")]
        [Parameter(Mandatory=$True,ParameterSetName="SitePath")]
        [Parameter(Mandatory=$True,ParameterSetName="GroupPath")]
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

        [Parameter(Mandatory=$True,ParameterSetName="AccountCertificate")]
        [Parameter(Mandatory=$True,ParameterSetName="SiteCertificate")]
        [Parameter(Mandatory=$True,ParameterSetName="GroupCertificate")]
        [String]
        $Certificate,

        [Parameter(Mandatory=$True,ParameterSetName="AccountBrowser")]
        [Parameter(Mandatory=$True,ParameterSetName="SiteBrowser")]
        [Parameter(Mandatory=$True,ParameterSetName="GroupBrowser")]
        [ValidateSet("chrome", "firefox", "edge", "ie")]
        [String]
        $Browser,

        [Parameter(Mandatory=$True,ParameterSetName="AccountFileType")]
        [Parameter(Mandatory=$True,ParameterSetName="SiteFileType")]
        [Parameter(Mandatory=$True,ParameterSetName="GroupFileType")]
        [String]
        $FileType,

        [Parameter(Mandatory=$True)]
        [ValidateSet("windows", "macos", "linux", "windows_legacy")]
        [String]
        $OSType,

        [Parameter(Mandatory=$False)]
        [String]
        $Description,
        
        [Parameter(Mandatory=$True,ParameterSetName="GroupBrowser")]
        [Parameter(Mandatory=$True,ParameterSetName="GroupCertificate")]
        [Parameter(Mandatory=$True,ParameterSetName="GroupFileType")]
        [Parameter(Mandatory=$True,ParameterSetName="GroupHash")]
        [Parameter(Mandatory=$True,ParameterSetName="GroupPath")]
        [String]
        $GroupID,

        [Parameter(Mandatory=$True,ParameterSetName="SiteBrowser")]
        [Parameter(Mandatory=$True,ParameterSetName="SiteCertificate")]
        [Parameter(Mandatory=$True,ParameterSetName="SiteFileType")]
        [Parameter(Mandatory=$True,ParameterSetName="SiteHash")]
        [Parameter(Mandatory=$True,ParameterSetName="SitePath")]
        [String]
        $SiteID,
        
        [Parameter(Mandatory=$True,ParameterSetName="AccountBrowser")]
        [Parameter(Mandatory=$True,ParameterSetName="AccountCertificate")]
        [Parameter(Mandatory=$True,ParameterSetName="AccountFileType")]
        [Parameter(Mandatory=$True,ParameterSetName="AccountHash")]
        [Parameter(Mandatory=$True,ParameterSetName="AccountPath")]
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
                type = ""
                value = ""
            }
            filter = @{}
        }

        if ($Path) {
            if (-not(Test-Path $Path -IsValid)) {
                Write-Error "Path is not valid"
                return
            }
            $Body.data.type = "path"
            $Body.data.Add("includeSubfolders", "false")
            $Body.data.Add("inject","true")
            $Body.data.value = $Path

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
            $Body.data.type = "certificate"
            $Body.data.value = $Certificate
        }
        if ($Browser) {
            $Body.data.type = "browser"
            $Body.data.value = $Browser
        }
        if ($FileType) {
            $Body.data.type = "file_type"
            $Body.data.value = $FileType
        }
        if ($Hash) {
            $Body.data.type = "white_hash"
            $Body.data.value = $Hash
        }
        

        if ($GroupID) { $Body.filter.Add("groupIds", @($GroupID -join ",")) }
        if ($SiteID) { $Body.filter.Add("siteIds", @($SiteID -join ",")) }
        if ($AccountID) { $Body.filter.Add("accountIds", @($AccountID -join ",")) }
        
        $URI = "/web/api/v2.1/exclusions"
        $Response = Invoke-S1Query -URI $URI -Method POST -Body ($Body | ConvertTo-Json) -ContentType "application/json"
        Write-Output $Response.data
    }
}