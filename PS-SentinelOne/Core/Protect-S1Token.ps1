function Protect-S1Token {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$True,ParameterSetName="String")]
        [String]
        $String
    )

    Begin {}
    Process {
        $SecureString = ConvertTo-SecureString -String $String -AsPlainText -Force
        $OutString = ConvertFrom-SecureString -SecureString $SecureString
        Write-Output -InputObject $OutString
    }
    End {}
}