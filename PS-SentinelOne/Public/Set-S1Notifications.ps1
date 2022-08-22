function Set-S1Notifications {

    [CmdletBinding(DefaultParameterSetName="All")]
    Param(
        [Parameter(Mandatory=$False)]
        [String[]]
        $AccountID,

		[Parameter(Mandatory=$True)]
        [String[]]
        $SiteID,

		[Parameter(Mandatory=$True)]
		[hashtable]
		$Notifications
    )
    Process {
        # Log the function and parameters being executed
        $InitializationLog = $MyInvocation.MyCommand.Name
        $MyInvocation.BoundParameters.GetEnumerator() | ForEach-Object { $InitializationLog += " -$($_.Key) $($_.Value)"}
        Write-Log -Message $InitializationLog -Level Informational

        $URI = "/web/api/v2.1/settings/notifications"

		$Body = @{
			data = @{ notifications = @{} }
			filter = @{}
		}

		If ($AccountID)	{ $Body.filter += @{ accountIds = ($AccountID -join ',') }}
		If ($SiteID)	{ $Body.filter += @{ siteIds = ($SiteID -join ',') }}

		$Body.data.notifications = $Notifications

		$Response = Invoke-S1Query -URI $URI -Method PUT -Body ($Body | ConvertTo-Json -Depth 99 -Compress) -ContentType 'application/json'

		Write-Output $Response.data
    }
}