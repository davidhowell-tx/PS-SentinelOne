function Get-S1Recipients {

    [CmdletBinding(DefaultParameterSetName="All")]
    Param(
        [Parameter(Mandatory=$False)]
        [String[]]
        $AccountID,

		[Parameter(Mandatory=$False)]
        [String]
        $Email,

		[Parameter(Mandatory=$False)]
        [String]
        $Name,

		[Parameter(Mandatory=$False)]
        [String]
        $Query,

		[Parameter(Mandatory=$False)]
        [String[]]
        $SiteIDs,

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
        $Parameters = @{}
        if ($AccountID) { $Parameters.Add("accountIds", ($AccountID -join ",")) }
		if ($Email)		{ $Parameters.Add("email", $Email) }
		if ($Name)		{ $Parameters.Add("name", $name) }
		if ($Query)		{ $Parameters.Add("query", $Query) }
		if ($SiteIDs)	{ $Parameters.Add("siteIds", ($SiteIDs -join ",")) }
		if ($SMS)		{ $Parameters.Add("sms", $SMS) }
        $Response = Invoke-S1Query -URI $URI -Method GET -Parameters $Parameters

		Write-Output $Response.data.recipients

    }
}