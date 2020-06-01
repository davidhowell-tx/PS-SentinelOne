function Invoke-S1Query {
    <#
    .SYNOPSIS
        Handles the request/response aspect of interacting with the SentinelOne API.

    .DESCRIPTION
        Handles the request/response aspect of interacting with the SentinelOne API, including pagination and error handling
    
    .PARAMETER URI
        The API URI from the SentinelOne API Documentation, i.e. "/web/api/v2.0/agents"
    
    .PARAMETER Parameters
        Hashtable containing the query string parameters used for filtering the results
    
    .PARAMETER ContentType
        Content Type of the body, if necessary, i.e. "application/json"
    
    .PARAMETER Method
        Rest method for the query.
    
    .PARAMETER Count
        Used to limit the number of results in the response, if supported by the specific API
    
    .PARAMETER Recurse
        Used to follow the cursor in paginated requests to retrieve all possible results
    
    .PARAMETER Body
        The body value for a POST or PUT request
    
    .OUTPUTS
        [PSCustomObject] in whatever format the API returns
    
    .EXAMPLE
        Invoke-S1Query -URI "/web/api/v2.0/agents" -Parameters @{computerName__contains = "hostname"} -Method GET
    #>
    [CmdletBinding(DefaultParameterSetName="Default")]
    Param(
        [Parameter(Mandatory=$True)]
        [String]
        $URI,   
    
        [Parameter(Mandatory=$False)]
        [Hashtable]
        $Parameters,

        [Parameter(Mandatory=$False)]
        [String]
        $ContentType,

        [Parameter(Mandatory=$False)]
        [ValidateSet("Get", "Post", "Put", "Delete")]
        [String]
        $Method = "Get",

        [Parameter(Mandatory=$False,ParameterSetName="Count")]
        [Uint32]
        $Count,

        [Parameter(Mandatory=$False,ParameterSetName="Recurse")]
        [Switch]
        $Recurse,

        [Parameter(Mandatory=$False)]
        $Body
    )
    if ($URI -ne "/web/api/v2.0/users/login") {
        # Log the function and parameters being executed
        $InitializationLog = $MyInvocation.MyCommand.Name
        $MyInvocation.BoundParameters.GetEnumerator() | ForEach-Object { $InitializationLog = $InitializationLog + " -$($_.Key) $($_.Value)"}
        Write-Log -Message $InitializationLog -Level Verbose

        # Attempt to retrieve cached configuration
        if ((-not $Script:PSSentinelOne.ApiToken -and -not $Script:PSSentinelOne.TemporaryToken) -or -not $Script:PSSentinelOne.ManagementURL) {
            Write-Log -Message "PS-SentinelOne Module Configuration not cached. Loading information from disk." -Level Verbose
            Get-S1ModuleConfiguration -Persisted -Cache
        }
    }

    # If no management URL is known, notify the user and exit
    if (-not $Script:PSSentinelOne.ManagementURL) {
        Write-Log -Message "Please use Set-S1ModuleConfiguration to save your management URL." -Level Error
        return
    }

    # If no token is present and not authenticating, notify the user and exit
    if (-not $Script:PSSentinelOne.ApiToken -and -not $Script:PSSentinelOne.TemporaryToken -and -not $URI -eq "/web/api/v2.0/users/login") {
        Write-Log -Message "Please use Set-S1ModuleConfiguration to save your APIToken, or use Get-S1Token to authenticate and generate a temporary token." -Level Error
        return
    }

    if ($URI -eq "/web/api/v2.0/groups" ) {
        $MaxCount = 100
    } else {
        $MaxCount = 1000
    }

    $Request = @{}
    $Request.Add("Method", $Method)
    $Request.Add("ErrorVariable", "RestError")
    if ($Script:PSSentinelOne.Proxy) {
        $Request.Add("Proxy", $Script:PSSentinelOne.Proxy)
    }
    if ($ContentType) {
        $Request.Add("ContentType", $ContentType)
    }
    if ($Body) {
        $Request.Add("Body", $Body)
    }
    $Headers = @{}
    if ($Script:PSSentinelOne.ApiToken) {
        $ApiToken = Unprotect-S1Token -String $Script:PSSentinelOne.ApiToken
        $Headers.Add("Authorization", "ApiToken $ApiToken")
    } elseif ($Script:PSSentinelOne.TemporaryToken) {
        $TemporaryToken = Unprotect-S1Token -String $Script:PSSentinelOne.TemporaryToken
        $Headers.Add("Authorization", "Token $TemporaryToken")
    }
    $Request.Add("Headers", $Headers)

    $URIBuilder = [System.UriBuilder]"$($Script:PSSentinelOne.ManagementURL)$URI"
    $QueryString = [System.Web.HttpUtility]::ParseQueryString([String]::Empty)
    if ($Parameters.Count -gt 0) {
        $Parameters.GetEnumerator() | ForEach-Object {
            $QueryString.Add($_.Name, $_.Value)       
        }
    }
    if ($Count) {
        if ($Count -lt $MaxCount) {
            $QueryString.Add("limit", $Count)
        } else {
            $QueryString.Add("limit", $MaxCount)
            $Count = $Count - $MaxCount
        }
    }
    if ($Recurse -and $QueryString -notcontains "limit") {
        $QueryString.Add("limit", $MaxCount)
    }
    if ($QueryString.Count -gt 0) {
        $URIBuilder.Query = $QueryString.ToString()
    }
    $Request.Add("URI", $URIBuilder.Uri.OriginalString)

    Try {
        Write-Log -Message "[$Method] $($URIBuilder.Uri.OriginalString)" -Level Informational
        $Response = Invoke-RestMethod @Request
    } Catch {
        Write-Log -Message $RestError.InnerException.Message -Level Warning
        return
    }
    Write-Output $Response

    if ($Recurse) {
        while ($Response.pagination.nextCursor) {
            $URIBuilder = [System.UriBuilder]"$($Script:PSSentinelOne.ManagementURL)$URI"
            $QueryString.Add("cursor", $Response.pagination.nextCursor)
            $URIBuilder.Query = $QueryString.ToString()
            $Request.URI = $URIBuilder.Uri.OriginalString
            Write-Log -Message "[$Method] $($URIBuilder.Uri.OriginalString)" -Level Informational
            $Response = Invoke-RestMethod @Request
            Write-Output $Response
    
            $QueryString.Remove("cursor")
        }
    }

    if ($Count) {
        while ($Count -gt 0) {
            $URIBuilder = [System.UriBuilder]"$($Script:PSSentinelOne.ManagementURL)$URI"
            if ($Count -lt $MaxCount) {
                $QueryString.Remove("limit")
                $QueryString.Add("limit", $Count)
            } else {
                $Count = $Count - $MaxCount
            }
            $URIBuilder.Query = $QueryString.ToString()
            $Request.URI = $URIBuilder.Uri.OriginalString
            Write-Log -Message "[$Method] $($URIBuilder.Uri.OriginalString)" -Level Informational
            $Response = Invoke-RestMethod @Request
            Write-Output $Response
        }
    }
}