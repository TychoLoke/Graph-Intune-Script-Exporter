# Script authored by Tycho Löke

# Check if NuGet module is already installed, if not install it
if (!(Get-Module -Name NuGet -ListAvailable)) {
    Install-Module NuGet -Force -Verbose
}

# Check if Microsoft.Graph.Intune module is already installed, if not install it
if (!(Get-Module -Name Microsoft.Graph.Intune -ListAvailable)) {
    Install-Module -Name Microsoft.Graph.Intune -Force -Verbose
}
Import-Module Microsoft.Graph.Intune -Global

# The path where the scripts will be saved
$ScriptPath = "C:\temp"

# Connect to Azure Graph
Connect-MSGraph

# Get Graph scripts
try {
    $ScriptsData = Invoke-MSGraphRequest -Url "https://graph.microsoft.com/beta/deviceManagement/deviceManagementScripts" -HttpMethod GET
    if (!$ScriptsData) {
        Write-Host "No scripts returned by the API. Please check your permissions and try again." -ForegroundColor Red
    } else {
        $ScriptsInfos = $ScriptsData.value
        $ScriptCount = $ScriptsInfos.count
        Write-Host "Found $ScriptCount scripts:" -ForegroundColor Yellow
        $ScriptsInfos | Select-Object DisplayName, filename | Format-Table
        Write-Host "Downloading Scripts..." -ForegroundColor Yellow
        foreach($ScriptInfo in $ScriptsInfos){
            # Get the script
            $Script = Invoke-MSGraphRequest -Url "https://graph.microsoft.com/beta/deviceManagement/deviceManagementScripts/$($ScriptInfo.id)" -HttpMethod GET
            # Save the script
            [System.Text.Encoding]::ASCII.GetString([System.Convert]::FromBase64String($Script.scriptContent)) | Out-File -FilePath (Join-Path $ScriptPath $Script.fileName) -Encoding ASCII
        }
        Write-Host "All scripts downloaded!" -ForegroundColor Yellow
    }
} catch {
    Write-Host "An error occurred: $($_.Exception.Message)" -ForegroundColor Red
}
