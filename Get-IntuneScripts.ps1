<#
.SYNOPSIS
    Retrieves and downloads Intune scripts from Microsoft Graph.

.DESCRIPTION
    - Ensures required PowerShell modules are installed.
    - Connects to Microsoft Graph API with specific permissions.
    - Retrieves Intune scripts and saves them locally.

.AUTHOR
    Tycho Löke

.LICENSE
    MIT License - Free to use and distribute.
#>

[CmdletBinding()]
param(
    [string]$ScriptPath = "C:\Temp",
    [switch]$ForceOverwrite
)

$ErrorActionPreference = "Stop"

function Initialize-PowerShellAdminHelpers {
    $moduleName = "PowerShellAdminHelpers"

    if (-not (Get-Module -ListAvailable -Name $moduleName)) {
        $installerPath = Join-Path -Path ([System.IO.Path]::GetTempPath()) -ChildPath "Install-PowerShellAdminHelpers.ps1"
        Invoke-WebRequest -Uri "https://raw.githubusercontent.com/TychoLoke/powershell-admin-helpers/main/Install-PowerShellAdminHelpers.ps1" -OutFile $installerPath
        & $installerPath
    }

    Import-Module -Name $moduleName -Force -ErrorAction Stop
}

try {
    Initialize-PowerShellAdminHelpers
    $ScriptPath = [System.IO.Path]::GetFullPath($ScriptPath)
    Write-Output "[INFO] Resolved path: $ScriptPath"
} catch {
    Write-Output "[ERROR] Invalid path entered: $($_.Exception.Message)"
    exit 1
}

# Ensure the directory exists
Write-Output "[INFO] Validating the directory path: $ScriptPath"
Ensure-OutputDirectory -Path $ScriptPath

Write-Output "`n=============================="
Write-Output "  Microsoft Intune Script Downloader"
Write-Output "==============================`n"

# Ensure required modules are installed
Ensure-Module -ModuleName "Microsoft.Graph"
Ensure-Module -ModuleName "Microsoft.Graph.DeviceManagement"

# Define required Graph API scopes
$Scopes = @("DeviceManagementConfiguration.Read.All")

# Connect to Microsoft Graph API
try {
    Write-Output "[INFO] Connecting to Microsoft Graph with required permissions..."
    Connect-GraphWithScopes -Scopes $Scopes
    Write-Output "[SUCCESS] Connected to Microsoft Graph with necessary permissions."
} catch {
    Write-Output "[ERROR] Could not connect to Microsoft Graph: $($_.Exception.Message)"
    exit 1
}

# Retrieve Intune scripts
try {
    Write-Output "[INFO] Retrieving Intune scripts..."
    $ScriptsData = Invoke-MgGraphRequest -Method GET -Uri "https://graph.microsoft.com/beta/deviceManagement/deviceManagementScripts"

    if (!$ScriptsData -or !$ScriptsData.value) {
        Write-Output "[WARNING] No scripts found. Check your permissions and try again."
        Exit 0
    }

    $ScriptsInfos = $ScriptsData.value
    $ScriptCount = $ScriptsInfos.Count
    Write-Output "[SUCCESS] Found $ScriptCount scripts."

    # Display script names
    $ScriptsInfos | Select-Object DisplayName, FileName | Format-Table

    # Download scripts
    Write-Output "[INFO] Downloading scripts..."
    foreach ($ScriptInfo in $ScriptsInfos) {
        $Script = Invoke-MgGraphRequest -Method GET -Uri "https://graph.microsoft.com/beta/deviceManagement/deviceManagementScripts/$($ScriptInfo.id)"
        $DecodedScript = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($Script.scriptContent))
        $FilePath = Join-Path -Path $ScriptPath -ChildPath $Script.FileName

        if ((Test-Path -Path $FilePath) -and -not $ForceOverwrite) {
            Write-Output "[WARNING] Skipping existing file: $($Script.FileName). Use -ForceOverwrite to replace it."
            continue
        }

        $DecodedScript | Set-Content -Path $FilePath -Encoding UTF8
        Write-Output "[SUCCESS] Downloaded: $($Script.FileName)"
    }

    Write-Output "[SUCCESS] All scripts downloaded successfully!"

} catch {
    Write-Output "[ERROR] Failed to retrieve or download scripts: $($_.Exception.Message)"
    exit 1
} finally {
    if (Get-MgContext) {
        Disconnect-MgGraph | Out-Null
    }
}
