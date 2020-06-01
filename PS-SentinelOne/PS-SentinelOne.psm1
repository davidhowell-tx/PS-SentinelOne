# Get a list of the included scripts and import them
$ModulePath = Split-Path $MyInvocation.MyCommand.Path -Parent
Get-ChildItem -Path $ModulePath -Filter *.ps1 -Recurse | ForEach-Object {
    if ($_.FullName -notlike '*.Tests.ps1') {
        . $_.FullName
    }
}

# Setup
Add-Type -AssemblyName System.Web
Set-Variable -Name PSSentinelOne -Value @{ ConfPath = [System.IO.Path]::Combine([Environment]::GetFolderPath("LocalApplicationData"),"PS-SentinelOne","config.json") } -Scope Script

# Core
Export-ModuleMember -Function Get-S1ModuleConfiguration
Export-ModuleMember -Function Set-S1ModuleConfiguration
Export-ModuleMember -Function Remove-S1ModuleConfiguration
Export-ModuleMember -Function Get-S1Token
Export-ModuleMember -Function Invoke-S1Query

# Activity
Export-ModuleMember -Function Get-S1Activity
Export-ModuleMember -Function Get-S1ActivityType

# Agent Actions
Export-ModuleMember -Function Invoke-S1FetchFile
Export-ModuleMember -Function Invoke-S1AgentAction
Export-ModuleMember -Function Move-S1Agent
Export-ModuleMember -Function Start-S1Scan
Export-ModuleMember -Function Stop-S1Scan

# Agents
Export-ModuleMember -Function Get-S1Agent
Export-ModuleMember -Function Get-S1Application
Export-ModuleMember -Function Get-S1Threat

# Exclusions
Export-ModuleMember -Function Get-S1Exclusion

# Policy
Export-ModuleMember -Function Get-S1Policy
Export-ModuleMember -Function Set-S1Policy

# Scope
Export-ModuleMember -Function Get-S1Account
Export-ModuleMember -Function Get-S1Site
Export-ModuleMember -Function Get-S1Group
Export-ModuleMember -Function New-S1Group
Export-ModuleMember -Function Remove-S1Group

