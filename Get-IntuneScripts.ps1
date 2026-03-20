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

try {
    $ScriptPath = [System.IO.Path]::GetFullPath($ScriptPath)
    Write-Output "[INFO] Resolved path: $ScriptPath"
} catch {
    Write-Output "[ERROR] Invalid path entered: $($_.Exception.Message)"
    Exit 1
}

# Ensure the directory exists
Write-Output "[INFO] Validating the directory path: $ScriptPath"
if (!(Test-Path -Path $ScriptPath -PathType Container)) {
    Write-Output "[INFO] Creating directory: $ScriptPath"
    New-Item -ItemType Directory -Force -Path $ScriptPath | Out-Null
}

Write-Output "`n=============================="
Write-Output "  Microsoft Intune Script Downloader"
Write-Output "==============================`n"

# Function to check and install missing modules
function Ensure-Module {
    param (
        [string]$ModuleName
    )
    try {
        if (!(Get-Module -Name $ModuleName -ListAvailable)) {
            Write-Output "[INFO] Installing module: $ModuleName..."
            Install-Module -Name $ModuleName -Force -ErrorAction Stop
            Write-Output "[SUCCESS] Module installed: $ModuleName"
        } else {
            Write-Output "[INFO] Module already installed: $ModuleName"
        }
    } catch {
    $ErrorMessage = $_.Exception.Message.ToString()
        Write-Output "[ERROR] Failed to install module $($ModuleName): $ErrorMessage"
        Exit 1
    }
}

# Ensure required modules are installed
Ensure-Module -ModuleName "Microsoft.Graph"

# Import Microsoft.Graph.DeviceManagement module
try {
    Import-Module Microsoft.Graph.DeviceManagement -Global -ErrorAction Stop
    Write-Output "[SUCCESS] Microsoft.Graph.DeviceManagement module imported."
} catch {
    Write-Output "[ERROR] Failed to import Microsoft.Graph module: $($_.Exception.Message)"
    Exit 1
}

# Define required Graph API scopes
$Scopes = @("DeviceManagementConfiguration.Read.All")

# Connect to Microsoft Graph API
try {
    Write-Output "[INFO] Connecting to Microsoft Graph with required permissions..."
    Connect-MgGraph -Scopes $Scopes -ErrorAction Stop
    Write-Output "[SUCCESS] Connected to Microsoft Graph with necessary permissions."
} catch {
    Write-Output "[ERROR] Could not connect to Microsoft Graph: $($_.Exception.Message)"
    Exit 1
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

        $DecodedScript | Out-File -FilePath $FilePath -Encoding UTF8
        Write-Output "[SUCCESS] Downloaded: $($Script.FileName)"
    }

    Write-Output "[SUCCESS] All scripts downloaded successfully!"

} catch {
    Write-Output "[ERROR] Failed to retrieve or download scripts: $($_.Exception.Message)"
    Exit 1
} finally {
    Disconnect-MgGraph | Out-Null
}
