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
Export-ModuleMember -Function Invoke-S1AgentAction
Export-ModuleMember -Function Move-S1Agent
Export-ModuleMember -Function Invoke-S1FetchFile
Export-ModuleMember -Function Get-S1AvailableActions

# Agents
Export-ModuleMember -Function Get-S1Agent
Export-ModuleMember -Function Get-S1Application
Export-ModuleMember -Function Get-S1Passphrase
Export-ModuleMember -Function Get-S1Threat

# Commands
Export-ModuleMember -Function Get-S1Command

# Deep Visibility Core
Export-ModuleMember -Function New-S1DVQuery
Export-ModuleMember -Function Get-S1DVQueryStatus
Export-ModuleMember -Function Get-S1DVEvents
Export-ModuleMember -Function New-S1DVCriteria

# Deep Visibility Extended
Export-ModuleMember -Function Format-S1DvEvent
Export-ModuleMember -Function Get-S1DvDnsRequest
Export-ModuleMember -Function Get-S1DvDnsResponse

# Exclusions
Export-ModuleMember -Function Get-S1Exclusion
Export-ModuleMember -Function New-S1Exclusion
Export-ModuleMember -Function Remove-S1Exclusion
Export-ModuleMember -Function Get-S1Blacklist
Export-ModuleMember -Function New-S1Blacklist 
Export-ModuleMember -Function Remove-S1Blacklist

# Hashes
Export-ModuleMember -Function Get-S1HashReputation

# Policy
Export-ModuleMember -Function Get-S1Policy
Export-ModuleMember -Function Set-S1Policy

# Scope
Export-ModuleMember -Function Get-S1Account
Export-ModuleMember -Function Get-S1Site
Export-ModuleMember -Function Get-S1Group
Export-ModuleMember -Function New-S1Group
Export-ModuleMember -Function Remove-S1Group

# Updates
Export-ModuleMember -Function Get-S1Package
Export-ModuleMember -Function Invoke-S1AgentUpdate