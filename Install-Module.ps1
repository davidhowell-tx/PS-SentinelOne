$CurrentPath = Split-Path $MyInvocation.MyCommand.Path -Parent

# Retrieve the configured paths for PowerShell Modules, and select the 1st entry.
# The first entry is typically a path specific to the user's profile
$ModulePath = ($Env:PSModulePath -split ";")[0]

# Copy the Module to the Module Path
Copy-Item -Path "$CurrentPath\PS-SentinelOne" -Destination $ModulePath -Recurse -Force -ErrorAction SilentlyContinue