function Unprotect-S1Token {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$True,ParameterSetName="String")]
        [String]
        $String
    )

    Begin {}
    Process {
        $SecureString = ConvertTo-SecureString -String $String
        $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecureString)
        $OutString = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)
        Write-Output -InputObject $OutString
    }
    End {}
}