function Set-S1Recipients {
	<#
	.NOTES 
		Author:			Chris Stone <chris.stone@nuwavepartners.com>
		Date-Modified:	2022-08-23 09:42:47

    .SYNOPSIS
        Change/Create Recipient for Notifications

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
        [String[]]
        $SiteID,

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
		If ($SiteID)	{ $Body.filter += @{ SiteID = ($SiteID -join ',') }}

		If ($Email)		{ $Body.data += @{ email = ($Email) }}
		If ($ID)		{ $Body.data += @{ id = ($ID) }}
		If ($Name)		{ $Body.data += @{ name = ($Name) }}
		If ($SMS)		{ $Body.data += @{ sms = ($SMS) }}
        
        $Response = Invoke-S1Query -URI $URI -Method PUT -Body ($Body | ConvertTo-Json -Compress) -ContentType 'application/json'

		Write-Output $Response.data

    }
}