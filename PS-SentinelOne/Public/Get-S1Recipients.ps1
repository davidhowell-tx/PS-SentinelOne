function Get-S1Recipients {
	<#
	.NOTES 
		Author:			Chris Stone <chris.stone@nuwavepartners.com>
		Date-Modified:	2022-08-23 09:44:09

    .SYNOPSIS
        Get Recipients for Notifications

    .PARAMETER AccountID
        Filter settings by Account scope
    
    .PARAMETER SiteID
        Filter settings by Site scope

	.PARAMETER Email 
		Email address to set/change

	.PARAMETER ID
		Recipient ID to Change. Only specify when changing an existing recipient.

	.PARAMETER Name
		Name to set/change

	.PARAMETER SMS
		SMS to set/change (deprecated)
    #>
	
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
        $SiteID,

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
		if ($SiteID)	{ $Parameters.Add("SiteID", ($SiteID -join ",")) }
		if ($SMS)		{ $Parameters.Add("sms", $SMS) }
        $Response = Invoke-S1Query -URI $URI -Method GET -Parameters $Parameters

		Write-Output $Response.data.recipients

    }
}