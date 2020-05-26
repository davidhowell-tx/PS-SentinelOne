function Set-S1ModuleConfiguration {
    <#
    .SYNOPSIS
        Sets the PS-SentinelOne module configuration values for connecting to the SentinelOne console
    
    .DESCRIPTION
        Sets the PS-SentinelOne module configuration values for connecting to the SentinelOne console
        Values can be set for the session only, or persisted to disk
    
    .PARAMETER URI
        Set the URI for your SentinelOne management console
    
    .PARAMETER ApiToken
        Set your ApiToken, retrieved from the API Token section of your user account in the SentinelOne management console

    .PARAMETER TemporaryToken
        Set your temporary token retrieved from the authentication API, using Get-S1Token
    
    .PARAMETER Persist
        Switch to specify that the configuration values should be saved to disk. Tokens are a secure string saved to disk. Path is in the user's local AppData directory
    #>
    [CmdletBinding()]
    Param(
		[Parameter(Mandatory=$False)]
		[String]
        $URI,

		[Parameter(Mandatory=$False)]
		[String]
        $ApiToken,
        
        [Parameter(Mandatory=$False)]
		[String]
        $TemporaryToken,
        
        [Parameter(Mandatory=$False)]
        [Switch]
        $Persist
    )
    # Log the command executed by the user
    $InitializationLog = $MyInvocation.MyCommand.Name
    $MyInvocation.BoundParameters.GetEnumerator() | ForEach-Object { $InitializationLog = $InitializationLog + " -$($_.Key) $($_.Value)"}
    Write-Log -Message $InitializationLog -Level Verbose

    # Serialize Tokens as SecureString
    if ($ApiToken) {
        $ApiTokenSecure = Protect-S1Token -String $APIToken
    }
    if ($TemporaryToken) {
        $TemporaryTokenSecure = Protect-S1Token -String $TemporaryToken
    }
    

    if ($URI) {
        if ($Script:PSSentinelOne.ManagementURL) {
            $Script:PSSentinelOne.ManagementURL = $URI
        } else {
            $Script:PSSentinelOne.Add("ManagementURL", $URI)
        }
    }
    if ($ApiToken) {
        if ($Script:PSSentinelOne.ApiToken) {
            $Script:PSSentinelOne.ApiToken = $ApiTokenSecure
        } else {
            $Script:PSSentinelOne.Add("ApiToken", $ApiTokenSecure)
        }
    }
    if ($TemporaryToken) {
        if ($Script:PSSentinelOne.TemporaryToken) {
            $Script:PSSentinelOne.TemporaryToken = $TemporaryTokenSecure
        } else {
            $Script:PSSentinelOne.Add("TemporaryToken", $TemporaryTokenSecure)
        }
    }

    if ($Persist) {
        $Configuration = Read-S1ModuleConfiguration -Path $Script:PSSentinelOne.ConfPath

        if (-not $Configuration) {
            $Configuration = [PSCustomObject]@{}
        }

        if ($URI) {
            if (-not $Configuration.URI) {
                Add-Member -InputObject $Configuration -MemberType NoteProperty -Name URI -Value $URI
            } else {
                $Configuration.URI = $URI
            }
        }

        if ($ApiToken) {
            if (-not $Configuration.ApiToken) {
                Add-Member -InputObject $Configuration -MemberType NoteProperty -Name ApiToken -Value $ApiTokenSecure
            } else {
                $Configuration.ApiToken = $ApiTokenSecure
            }
        }
        
        Save-S1ModuleConfiguration -Path $Script:PSSentinelOne.ConfPath -InputObject $Configuration
    }
}