function Get-S1Token {
    <#
    .SYNOPSIS
        Authenticate with your username and password to the SentinelOne console and retrieve the returned temporary token for subsequent requests.
    
    .PARAMETER Credentials
        The credentials to use to authenticate with the SentinelOne console
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$False)]
        [pscredential]
        $Credentials
    )

    if (-not $Credentials) {
        Write-Log -Message "No credentials provided. Prompting for credentials." -Level Verbose
        $Credentials = Get-Credential -Message "Input SentinelOne username and password to authenticate for a temporary API token."
    }

    $Method = "Post"
    $URI = "/web/api/v2.0/users/login"
    $ContentType = "application/json"
    $Body = @{
        username = $Credentials.UserName
        password = $Credentials.GetNetworkCredential().Password
        remember_me = "true"
    }

    Try {
        $Response = Invoke-S1Query -URI $URI -ContentType $ContentType -Method $Method -Body ($Body | ConvertTo-Json)
    } Catch {
        Write-Host $_.Exception.Message
        Write-Host ($_.ErrorDetails.Message | ConvertFrom-Json | Select-Object -ExpandProperty errors)
        return
    }

    Set-S1ModuleConfiguration -TemporaryToken $Response.data.token
}