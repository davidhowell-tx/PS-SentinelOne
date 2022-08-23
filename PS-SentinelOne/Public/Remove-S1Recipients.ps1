function Remove-S1Recipients {
	<#
	.NOTES 
		Author:			Chris Stone <chris.stone@nuwavepartners.com>
		Date-Modified:	2022-08-23 09:43:08

    .SYNOPSIS
        Remove Recipient for Notifications

    .PARAMETER ID
		ID of the Recipient to Remove
    #>

    [CmdletBinding(DefaultParameterSetName="All")]
    Param(
		[Parameter(Mandatory=$True)]
        [String]
        $ID
    )
    Process {
        # Log the function and parameters being executed
        $InitializationLog = $MyInvocation.MyCommand.Name
        $MyInvocation.BoundParameters.GetEnumerator() | ForEach-Object { $InitializationLog += " -$($_.Key) $($_.Value)"}
        Write-Log -Message $InitializationLog -Level Informational

        $URI = "/web/api/v2.1/settings/recipients/$ID"

        $Response = Invoke-S1Query -URI $URI -Method DELETE

		Write-Output $Response.data.success

    }
}