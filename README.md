# bash-script
A collection of professional installation scripts for Java development environments.

## Boiler plate code for bash-scripts (Linux/macOS)

### To install SDKMAN, JAVA, MAVEN, and SPRING-CLI
```bash
# Create the .scripts directory if it doesn't exist
mkdir -p ~/.scripts
# Download the script into the .scripts directory
curl -o ~/.scripts/install-java.sh https://raw.githubusercontent.com/joshuasalcedo-template/bash-script/refs/heads/main/java/install-java.sh
# Make the script executable
chmod +x ~/.scripts/install-java.sh
# Run the installer
~/.scripts/install-java.sh
```

### To Install IntelliJ Toolbox
```bash
# Create the .scripts directory if it doesn't exist
mkdir -p ~/.scripts
# Download the script into the .scripts directory
curl -o ~/.scripts/intellij.sh https://raw.githubusercontent.com/joshuasalcedo-template/bash-script/refs/heads/main/application/intellij.sh
# Make the script executable
chmod +x ~/.scripts/intellij.sh
# Run the installer
~/.scripts/intellij.sh
```

## Windows PowerShell Script

### To install Java, JavaFX, Maven, and IntelliJ Toolbox
```powershell
# Create a directory for scripts if it doesn't exist
$scriptDir = "$env:USERPROFILE\JavaScripts"
New-Item -Path $scriptDir -ItemType Directory -Force

# Download the PowerShell script
$scriptUrl = "https://raw.githubusercontent.com/joshuasalcedo-template/bash-script/main/java/powershell/java-setup.ps1"
$scriptPath = "$scriptDir\java-setup.ps1"
Invoke-WebRequest -Uri $scriptUrl -OutFile $scriptPath

# Run the script with admin privileges (requires right-click and "Run as Administrator")
Write-Host "Script downloaded to: $scriptPath"
Write-Host "Right-click on the script in Windows Explorer and select 'Run with PowerShell as Administrator' to execute it"
```

Alternatively, to download and run in one step (requires running PowerShell as Administrator):
```powershell
# Run script directly (PowerShell must be started as Administrator)
Set-ExecutionPolicy Bypass -Scope Process -Force
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/joshuasalcedo-template/bash-script/main/java/powershell/java-setup.ps1'))
```

## Features

### Java Development Environment (install-java.sh for Linux/macOS)
- Installs SDKMAN for easy Java version management
- Configures the latest LTS Java version
- Installs and configures Maven for dependency management
- Sets up Spring CLI for rapid Spring application development
- Configures shell environment variables automatically

### Java Development Environment (java-setup.ps1 for Windows)
- Downloads and installs multiple JDK versions (17, 21, 24)
- Configures JavaFX (23.0.2 and 24)
- Sets up Maven for dependency management
- Installs IntelliJ Toolbox for IDE access
- Configures Windows environment variables automatically
- Sets Java 17 as the default JAVA_HOME

### IntelliJ Toolbox Installer (intellij.sh for Linux/macOS)
- Installs required dependencies (libfuse2)
- Downloads the latest version of JetBrains Toolbox App
- Automatically handles extraction and installation
- Creates desktop shortcuts for easy access
- Detects existing installations to prevent duplicates
- Supports automatic JetBrains account login and license activation

## Requirements

### For Linux/macOS scripts:
- Debian/Ubuntu-based Linux distribution or macOS
- Admin (sudo) privileges
- Bash shell
- Internet connection

### For Windows scripts:
- Windows 10/11
- PowerShell 5.1 or newer
- Administrator privileges
- Internet connection

## Usage

After installation:

1. **Java Development**:
   - Linux/macOS (via SDKMAN):
     - Use SDKMAN to manage Java versions: `sdk list java`
     - Install specific Java versions: `sdk install java 17.0.2-tem`
     - Switch between versions: `sdk use java 17.0.2-tem`
   - Windows:
     - Use environment variables (`JAVA17_HOME`, `JAVA21_HOME`, etc.)
     - Switch versions by updating `JAVA_HOME` in your environment variables
     - Access JavaFX libraries via `PATH_TO_FX` environment variable

2. **IntelliJ IDEA**:
   - Launch IntelliJ Toolbox from your application menu
   - Log in with your JetBrains account
   - Install IntelliJ IDEA Community or Ultimate edition
   - Optionally install other JetBrains products (WebStorm, PyCharm, etc.)
