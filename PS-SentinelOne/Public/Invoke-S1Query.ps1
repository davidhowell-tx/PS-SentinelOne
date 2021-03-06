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
    
    .PARAMETER MaxCount
        Specify the maximum number of results allowed by the API. This value differs between APIs with a default of 100
    
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

        [Parameter(Mandatory=$False)]
        [Uint32]
        $MaxCount=100,

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

    # Start building request
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

    # Build request headers and add to request
    $Headers = @{}
    if ($Script:PSSentinelOne.ApiToken) {
        $ApiToken = Unprotect-S1Token -String $Script:PSSentinelOne.ApiToken
        $Headers.Add("Authorization", "ApiToken $ApiToken")
    } elseif ($Script:PSSentinelOne.TemporaryToken) {
        $TemporaryToken = Unprotect-S1Token -String $Script:PSSentinelOne.TemporaryToken
        $Headers.Add("Authorization", "Token $TemporaryToken")
    }
    $Request.Add("Headers", $Headers)

    # Start building request URI
    $URIBuilder = [System.UriBuilder]"$($Script:PSSentinelOne.ManagementURL)$($URI.Trim("/"))"
    $QueryString = [System.Web.HttpUtility]::ParseQueryString([String]::Empty)

    # Add any parameters supplied with -Parameters switch to Query String
    if ($Parameters.Count -gt 0) {
        $Parameters.GetEnumerator() | ForEach-Object {
            $QueryString.Add($_.Name, $_.Value)       
        }
    }

    # Process result limit
    if ($Count) {
        if ($Count -lt $MaxCount) {
            $QueryString.Add("limit", $Count)
            $Count = $Count - $Count
        } else {
            $QueryString.Add("limit", $MaxCount)
            $Count = $Count - $MaxCount
        }
    }
    if ($Recurse -and $QueryString -notcontains "limit") {
        $QueryString.Add("limit", $MaxCount)
    }

    # Add querystring to URI
    if ($QueryString.Count -gt 0) {
        $URIBuilder.Query = $QueryString.ToString()
    }

    # Add URI to request
    $Request.Add("URI", $URIBuilder.Uri.OriginalString)

    # Send request
    Try {
        Write-Log -Message "[$Method] $($URIBuilder.Uri.OriginalString)" -Level Verbose
        $Response = Invoke-RestMethod @Request
    } Catch {
        Write-Log -Message $RestError.InnerException.Message -Level Warning
        Write-Log -Message $RestError.Message -Level Warning
        Throw
    }

    if ($Parameters.countOnly) {
        Write-Output $Response.pagination.totalItems
    } else {
        Write-Output $Response
    }
    
    # Recurse through all results using the pagination cursor
    if ($Recurse) {
        while ($Response.pagination.nextCursor) {
            $URIBuilder = [System.UriBuilder]"$($Script:PSSentinelOne.ManagementURL)$($URI.Trim("/"))"
            $QueryString.Add("cursor", $Response.pagination.nextCursor)
            $URIBuilder.Query = $QueryString.ToString()
            $Request.URI = $URIBuilder.Uri.OriginalString
            Write-Log -Message "[$Method] $($URIBuilder.Uri.OriginalString)" -Level Verbose
            $Response = Invoke-RestMethod @Request
            Write-Output $Response
    
            $QueryString.Remove("cursor")
        }
    }

    # Recurse through results until requested count is met. This could result in too many results, the commandlets should deal with returning exact numbers
    if ($Count) {
        while ($Count -gt 0 -and $Response.pagination.nextCursor) {
            $URIBuilder = [System.UriBuilder]"$($Script:PSSentinelOne.ManagementURL)$($URI.Trim("/"))"
            $QueryString.Add("cursor", $Response.pagination.nextCursor)
            $URIBuilder.Query = $QueryString.ToString()
            $Request.URI = $URIBuilder.Uri.OriginalString
            Write-Log -Message "[$Method] $($URIBuilder.Uri.OriginalString)" -Level Verbose
            $Response = Invoke-RestMethod @Request
            Write-Output $Response
            if ($Count -lt $MaxCount) {
                $Count = $Count - $Count
            } else {
                $Count = $Count - $MaxCount
            }
            $QueryString.Remove("cursor")
        }
    }
}