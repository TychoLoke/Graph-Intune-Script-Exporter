# 🚀 Intune Script Retriever  

This **PowerShell script**, authored by **Tycho Löke**, automates the process of retrieving and downloading **all scripts associated with your Intune account** via the **Microsoft Graph API**.  

The downloaded scripts are saved locally at **`C:\temp`** by default.  

## 📌 Features  
✅ **Automated Intune Script Retrieval** – Fetches all scripts linked to your Intune tenant.  
✅ **Secure Authentication** – Uses Microsoft Graph authentication for seamless access.  
✅ **Module Installation Handling** – Ensures required PowerShell modules are installed before execution.  
✅ **User-Friendly Logging** – Displays script names and status updates in real-time.  
✅ **Efficient & Non-Destructive** – Prevents redundant installations and unnecessary re-execution.  

## 🛠 Prerequisites  
Before running the script, ensure you meet the following requirements:  

- **Azure Active Directory (AAD)** – Must have an **Intune subscription**.  
- **Admin Role** – Requires **Global Admin** or **Intune Admin** role in AAD.  
- **PowerShell with Elevated Permissions** – Run as Administrator.  
- **Internet Connectivity** – Needed to install required PowerShell modules.  

## 🚀 How to Use  

### **1️⃣ Download the Script**  
Clone this repository or download the script file manually.  

```powershell
git clone https://github.com/your-repo/intune-script-retriever.git
cd intune-script-retriever
```

### **2️⃣ Run PowerShell as Administrator**  
- Open **PowerShell** with elevated permissions (`Run as Administrator`).  

### **3️⃣ Execute the Script**  
Run the script using:  

```powershell
.\Intune-Script-Retriever.ps1
```

### **4️⃣ Authenticate with Microsoft Graph**  
- Sign in with your **AAD Global Admin** or **Intune Admin** credentials when prompted.  

### **5️⃣ What Happens Next?**  
✅ The script **checks for required modules** (`NuGet` & `Microsoft.Graph.Intune`).  
✅ If missing, it **installs them automatically**.  
✅ The script **connects to the Microsoft Graph API**.  
✅ Retrieves **all Intune scripts** and displays their **names**.  
✅ Downloads and **saves scripts locally** to **`C:\temp`**.  
✅ Displays a **success message** once all scripts are downloaded.  

## 🔎 Notes  
- The script uses the **beta** version of the **Microsoft Graph API for Intune**.  
- Scripts are saved in **ASCII encoding** for compatibility.  
- If a script with the same name already exists, it will be **overwritten**.  
- To change the save location, modify the `$ScriptPath` variable in the script.  

## 🛠 Troubleshooting  

### ❌ Unable to connect to Microsoft Graph API?  
- Verify that you have the correct **AAD permissions** and an **active Intune subscription**.  

### ❌ Script fails to install required modules?  
- Ensure you have **internet connectivity** and that your **PowerShell execution policy** allows module installation.  

### ❌ Error messages during execution?  
- Check the **PowerShell output** and verify if required permissions or dependencies are missing.  

## 🤝 Contributing  
Want to improve this script? Contributions are welcome!  

**To contribute:**  
1. **Fork** the repository.  
2. **Create a feature branch** (`git checkout -b feature-name`).  
3. **Submit a Pull Request** with your changes.  

## 📜 License  
This project is licensed under the **MIT License** – feel free to use, modify, and distribute it.  
