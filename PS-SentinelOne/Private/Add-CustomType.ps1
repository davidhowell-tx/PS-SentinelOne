function Add-CustomType {
    <#
    .SYNOPSIS
        Function to abstract away the process of adding a type name to a PSCustomObject
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$True,ValueFromPipeline=$True)]
        [PSCustomObject]
        $InputObject,

        [Parameter(Mandatory=$True)]
        [String]
        $CustomTypeName
    )
    Process {
        $InputObject.PSObject.TypeNames.Insert("0", $CustomTypeName)
        Write-Output $InputObject
    }
}