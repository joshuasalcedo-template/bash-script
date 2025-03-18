
#!/bin/bash

# SWA Development Environment Installer
# Created: March 12, 2025

# Define colors
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Define the banner
BANNER=$(cat << 'EOF'
   _______          **      **_____          __         
  / ____\ \        / /\    / ____\ \        / /\        
 | (___  \ \  /\  / /  \  | (___  \ \  /\  / /  \       
  \___ \  \ \/  \/ / /\ \  \___ \  \ \/  \/ / /\ \      
  ____) |  \  /\  / ____ \ ____) |  \  /\  / ____ \     
 |_____/ ___\/__\/_/   *\*\_____/ ___\/_ \/_/___ \_\  __
 |  ** \|  **__\ \    / /        |  ____| \ | \ \    / /
 | |  | | |__   \ \  / /   ______| |__  |  \| |\ \  / / 
 | |  | |  **|   \ \/ /   |**____|  __| | . ` | \ \/ /  
 | |__| | |____   \  /           | |____| |\  |  \  /   
 |_____/|______|   \/            |______|_| \_|   \/    
EOF
)

# Print banner
echo -e "${BLUE}$BANNER${NC}"
echo -e "${BLUE}SWA Development Environment Installer${NC}"
echo -e "${YELLOW}This script will install and configure java using SDKMAN.${NC}"
echo



    INSTALL_SYSTEM=y
    INSTALL_JAVA=y
    INSTALL_MAVEN=y


echo
read -p "Proceed with installation? (y/n) [y]: " CONFIRM
CONFIRM=${CONFIRM:-y}

if [ "$CONFIRM" != "y" ]; then
    echo -e "${YELLOW}Installation cancelled.${NC}"
    exit 0
fi

echo -e "\n${GREEN}Starting installation...${NC}\n"

# Update and upgrade the system
if [ "$INSTALL_SYSTEM" = "y" ]; then
    echo -e "${BLUE}Updating system packages...${NC}"
    sudo apt update && sudo apt upgrade -y
    sudo apt install -y tree zip curl wget
    echo -e "${GREEN}System updates completed.${NC}\n"
fi

# Install SDKMAN and Java
if [ "$INSTALL_JAVA" = "y" ]; then
    echo -e "${BLUE}Installing SDKMAN and Java 17...${NC}"
    if [ ! -d "$HOME/.sdkman" ]; then
        curl -s "https://get.sdkman.io" | bash
        source "$HOME/.sdkman/bin/sdkman-init.sh"
    else
        source "$HOME/.sdkman/bin/sdkman-init.sh"
    fi
    sdk install java 17.0.14-amzn
    sdk install java 23.0.2-graal
    sdk install java 21.0.6-amzn 
    sdk install 
    echo -e "${GREEN}Java 17 installation completed.${NC}\n"
fi

# Install Spring CLI
if [ "$INSTALL_JAVA" = "y" ]; then
    echo -e "${BLUE}Installing Spring CLI...${NC}"
    
    # Set JAVA_HOME to the GraalVM installation for best compatibility
    JAVA_HOME=$(sdk home java 17.0.14-amzn)
    export JAVA_HOME
    export PATH=$JAVA_HOME/bin:$PATH
    
    # Create a temporary directory for Spring CLI source
    SPRING_CLI_DIR="$HOME/.temp/spring-cli"
    mkdir -p "$SPRING_CLI_DIR"
    
    # Clone the Spring CLI repository
    git clone https://github.com/spring-projects/spring-cli "$SPRING_CLI_DIR"
    
    # Build Spring CLI
    cd "$SPRING_CLI_DIR"
    ./gradlew clean build -x test
    
    # Create alias for Spring CLI in .bashrc
    SPRING_ALIAS="alias spring='java -jar $SPRING_CLI_DIR/build/libs/spring-cli-0.10.0-SNAPSHOT.jar'"
    
    if ! grep -q "alias spring=" "$HOME/.bashrc"; then
        echo "$SPRING_ALIAS" >> "$HOME/.bashrc"
    fi
    
    echo -e "${GREEN}Spring CLI installation completed.${NC}"
    echo -e "${YELLOW}Use 'spring' command after restarting your terminal or run 'source ~/.bashrc'${NC}\n"
fi




# Install Maven
if [ "$INSTALL_MAVEN" = "y" ]; then
    echo -e "${BLUE}Installing Maven...${NC}"
    sudo apt install -y maven
    echo -e "${GREEN}Maven installation completed.${NC}\n"
fi


# Print Installed Software Versions
echo -e "\n${YELLOW}=== Installed Software Versions ===${NC}"
echo -e "Java: $(java 17.0.14-amzn)"
echo -e "Java: $( java 23.0.2-graal)"
echo -e "Java: $(java 21.0.6-amzn )"
echo -e "Maven: $(mvn -version | head -n 1)"

echo -e "${GREEN}Installation complete! 🚀${NC}"
echo -e "Type '${YELLOW}clear${NC}' or restart your terminal to see your new banner!\n"
