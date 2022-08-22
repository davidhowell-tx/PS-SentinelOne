function Set-S1Recipients {

    [CmdletBinding(DefaultParameterSetName="All")]
    Param(
        [Parameter(Mandatory=$False)]
        [String[]]
        $AccountID,

		[Parameter(Mandatory=$False)]
        [String[]]
        $SiteIDs,

		[Parameter(Mandatory=$False)]
        [String]
        $Email,

		[Parameter(Mandatory=$False)]
        [String]
        $ID,

		[Parameter(Mandatory=$False)]
        [String]
        $Name,

		[Parameter(Mandatory=$False)]
        [String]
        $SMS
    )
    Process {
        # Log the function and parameters being executed
        $InitializationLog = $MyInvocation.MyCommand.Name
        $MyInvocation.BoundParameters.GetEnumerator() | ForEach-Object { $InitializationLog += " -$($_.Key) $($_.Value)"}
        Write-Log -Message $InitializationLog -Level Informational

        $URI = "/web/api/v2.1/settings/recipients"

		$Body = @{
			data = @{}
			filter = @{}
		}

		If ($AccountID)	{ $Body.filter += @{ accountIds = ($AccountID -join ',') }}
		If ($SiteIDs)	{ $Body.filter += @{ siteIds = ($SiteIDs -join ',') }}

		If ($Email)		{ $Body.data += @{ email = ($Email) }}
		If ($ID)		{ $Body.data += @{ id = ($ID) }}
		If ($Name)		{ $Body.data += @{ name = ($Name) }}
		If ($SMS)		{ $Body.data += @{ sms = ($SMS) }}
        
        $Response = Invoke-S1Query -URI $URI -Method PUT -Body ($Body | ConvertTo-Json -Compress) -ContentType 'application/json'

		Write-Output $Response.data

    }
}