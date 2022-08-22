function Get-S1Notifications {

    [CmdletBinding(DefaultParameterSetName="All")]
    Param(
        [Parameter(Mandatory=$False)]
        [String[]]
        $AccountID,

		[Parameter(Mandatory=$True)]
        [String[]]
        $SiteID,

		[Parameter(Mandatory=$False)]
		[ValidateSet('Data', 'Raw')]
		[String]
		$ResponseFilter = 'Data'
    )
    Process {
        # Log the function and parameters being executed
        $InitializationLog = $MyInvocation.MyCommand.Name
        $MyInvocation.BoundParameters.GetEnumerator() | ForEach-Object { $InitializationLog += " -$($_.Key) $($_.Value)"}
        Write-Log -Message $InitializationLog -Level Informational

        $URI = "/web/api/v2.1/settings/notifications"
        $Parameters = @{}
        if ($SiteID) { $Parameters.Add("siteIds", ($SiteID -join ","))}
        if ($AccountID) { $Parameters.Add("accountIds", ($AccountID -join ",")) }
        $Response = Invoke-S1Query -URI $URI -Method GET -Parameters $Parameters
		
        Switch ($ResponseFilter) {
			'Raw'	{
				Write-Output $Response.data.notifications
				Break
			}
			'Data' {
				$Output = @{}
				foreach ($Section in $Response.data.notifications.PSObject.Properties.Name) {
					$Output += @{ $Section = @{} }
					foreach ($Conf in ($Response.data.notifications.$Section.PSObject.Properties.Name | Where-Object { $_ -notin @('name','id') })) {
						$Output.$Section += @{ $Conf = @{ 
							email = $Response.data.notifications.$Section.$Conf.email;
							syslog = $Response.data.notifications.$Section.$Conf.syslog
						} }
					}
				}
				Write-Output $Output
				Break
			}
		}
    }
}