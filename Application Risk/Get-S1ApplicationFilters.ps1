function Get-S1Filter {
    <#
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$True)]
        [ValidateSet(
            "Agent",
            "Application"
        )]
        [String]
        $Type
    )
    Process {
        # Log the function and parameters being executed
        $InitializationLog = $MyInvocation.MyCommand.Name
        $MyInvocation.BoundParameters.GetEnumerator() | ForEach-Object { $InitializationLog = $InitializationLog + " -$($_.Key) $($_.Value)"}
        Write-Log -Message $InitializationLog -Level Informational
        
        $Method = "Get"

        switch ($Type) {
            "Application" {
                $URI = "/web/api/v2.0/private/installed-applications/free-text-filters"
            }
        }

        $Response = Invoke-S1Query -URI $URI -Method $Method
        Write-Output $Response.data
    }
}