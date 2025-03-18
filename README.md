# bash-script
A collection of professional installation scripts for Java development environments.

## Boiler plate code for bash-scripts

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

## Features

### Java Development Environment (install-java.sh)
- Installs SDKMAN for easy Java version management
- Configures the latest LTS Java version
- Installs and configures Maven for dependency management
- Sets up Spring CLI for rapid Spring application development
- Configures shell environment variables automatically

### IntelliJ Toolbox Installer (intellij.sh)
- Installs required dependencies (libfuse2)
- Downloads the latest version of JetBrains Toolbox App
- Automatically handles extraction and installation
- Creates desktop shortcuts for easy access
- Detects existing installations to prevent duplicates
- Supports automatic JetBrains account login and license activation

## Requirements
- Debian/Ubuntu-based Linux distribution
- Admin (sudo) privileges
- Bash shell
- Internet connection

## Usage
After installation:

1. **Java Development**:
   - Use SDKMAN to manage Java versions: `sdk list java`
   - Install specific Java versions: `sdk install java 17.0.2-tem`
   - Switch between versions: `sdk use java 17.0.2-tem`

2. **IntelliJ IDEA**:
   - Launch IntelliJ Toolbox from your application menu
   - Log in with your JetBrains account
   - Install IntelliJ IDEA Community or Ultimate edition
   - Optionally install other JetBrains products (WebS
