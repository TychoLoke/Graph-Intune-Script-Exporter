# Graph Intune Script Exporter

[![Release](https://img.shields.io/github/v/release/TychoLoke/Graph-Intune-Script-Exporter)](https://github.com/TychoLoke/Graph-Intune-Script-Exporter/releases)
[![CI](https://img.shields.io/github/actions/workflow/status/TychoLoke/Graph-Intune-Script-Exporter/powershell-ci.yml?branch=main)](https://github.com/TychoLoke/Graph-Intune-Script-Exporter/actions/workflows/powershell-ci.yml)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

This PowerShell script exports Microsoft Intune device management scripts through Microsoft Graph and saves each script locally.

## What It Does

- Connects to Microsoft Graph with delegated read-only access
- Downloads all Intune device management scripts from the tenant
- Saves script content as UTF-8 files
- Skips existing files unless you pass `-ForceOverwrite`
- Bootstraps `PowerShellAdminHelpers` from `TychoLoke/powershell-admin-helpers` if needed

## Requirements

- PowerShell 7 recommended
- An account that can read Intune device management configuration
- Permission to install PowerShell modules for the current user
- Internet access the first time you run the script so it can bootstrap the shared helper module

## Usage

```powershell
.\Get-IntuneScripts.ps1 -ScriptPath "C:\Temp\IntuneScripts"
```

To overwrite existing local files:

```powershell
.\Get-IntuneScripts.ps1 -ScriptPath "C:\Temp\IntuneScripts" -ForceOverwrite
```

## Notes

- The script uses the `DeviceManagementConfiguration.Read.All` delegated Graph scope.
- `Microsoft.Graph` and `Microsoft.Graph.DeviceManagement` are installed automatically if they are missing.
- The output directory is created automatically if it does not exist.

## License

This project is licensed under the MIT License.
