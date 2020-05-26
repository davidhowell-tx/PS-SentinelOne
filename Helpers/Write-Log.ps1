function Write-Log {
    <#
    .SYNOPSIS
        Converts the supplied message into a consistent log format

    .PARAMETER Message
        The message to be logged. 
    
    .PARAMETER Level
        The log level of the message to be logged.
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$True)]
        [String[]]
        $Message,

        [Parameter()]
        [ValidateSet(
            "Error",
            "Warning",
            "Verbose",
            "Informational"
        )]
        [String]
        $Level = "Informational"
    )
    ForEach ($Entry in $Message) {
        $DateTime = Get-Date -Format "yyyy-MM-ddTHH:mm:ssK"
        $Username = "$Env:USERDOMAIN\$Env:USERNAME"
        $LogMessage = "$DateTime [$($Level.ToUpper())] - User: $Username, Message: $Entry"

        switch ($Level) {
            "Informational" {
                Write-Host $LogMessage
            }
            "Verbose" {
                Write-Verbose $LogMessage
            }
            "Error" {
                Write-Error $LogMessage -ErrorAction Continue
            }
            "Warning" {
                Write-Warning $LogMessage
            }
        }
    }
}