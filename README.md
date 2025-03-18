# bash-script

## Boiler plate code for bash-scripts


### To install SDKMAN, JAVA, MAVEN, and SPRING-CLI
```
# Create the .scripts directory if it doesn't exist
mkdir -p ~/.scripts

# Download the script into the .scripts directory
curl -o ~/.scripts/install-java.sh https://raw.githubusercontent.com/joshuasalcedo-template/bash-script/refs/heads/main/java/install-java.sh

# Make the script executable
chmod +x ~/.scripts/install-java.sh

# Run the installer
~/.scripts/install-java.sh
```
