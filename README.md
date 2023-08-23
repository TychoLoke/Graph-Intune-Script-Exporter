# Intune-Script-Retriever

This PowerShell script, authored by Tycho Löke, allows you to download all the scripts that are associated with your Intune account. The scripts will be saved to a specified local directory (`C:\temp` by default).

## Prerequisites

- An Azure Active Directory (AAD) tenant with an Intune subscription.
- A Global Administrator or Intune role in AAD.
- PowerShell with elevated permissions.
- Internet connectivity to install the required NuGet and Microsoft.Graph.Intune PowerShell modules.

## Usage
1. Clone or download the script from this repository.
2. Open a PowerShell window with elevated permissions.
3. Run the script by typing `.\Intune-Script-Retriever.ps1`.
4. When prompted, sign in with your AAD credentials.
5. The script will check if the NuGet and Microsoft.Graph.Intune modules are installed. If they are not, the script will install them.
6. The script will then connect to the Microsoft Graph API and retrieve a list of all the scripts associated with your Intune account.
7. The script will display the number of scripts found and their names.
8. The script will then download the scripts and save them to the specified local directory (`C:\temp`).
9. The script will display a message indicating that all the scripts have been downloaded.

## Notes
- The script uses the beta version of the Microsoft Graph API for Intune.
- The script saves the scripts in ASCII encoding.
- The script will overwrite any existing files in the specified directory with the same name as the downloaded scripts.
- Ensure the specified directory exists or modify the `$ScriptPath` variable in the script to the desired path.

## Troubleshooting
- If the script is unable to connect to the Microsoft Graph API, check that you have the correct permissions in AAD and that your Intune subscription is active.
- If the script returns an error message, check the error message and the script's output for more information.
- If the script is unable to install the NuGet or Microsoft.Graph.Intune modules, check that you have internet connectivity and that your PowerShell execution policy allows for the installation of modules.

## Contribution
If you want to improve this script, please feel free to open a pull request.

## License
This script is licensed under the MIT license.
