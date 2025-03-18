#!/bin/bash
# SWA Development Environment Installer
# Created: March 12, 2025
# Define colors
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color
# Define the banner
BANNER=$(cat << 'EOF'
   _______          **      **_____          __         
  / ____\ \        / /\    / ____\ \        / /\        
 | (___  \ \  /\  / /  \  | (___  \ \  /\  / /  \       
  \___ \  \ \/  \/ / /\ \  \___ \  \ \/  \/ / /\ \      
  ____) |  \  /\  / ____ \ ____) |  \  /\  / ____ \     
 |_____/ ___\/__\/_/   *\*\_____/ ___\/_ \/_/___ \_\  __
 |  ** \|  \ \    / /        |  **__| \ | \ \    / /
 | |  | | |__   \ \  / /   ______| |__  |  \| |\ \  / / 
 | |  | |  **|   \ \/ /   |**____|  __| | . ` | \ \/ /  
 | |__| | |____   \  /           | |____| |\  |  \  /   
 |_____/|______|   \/            |______|_| \_|   \/    
EOF
)

# Function to check command existence
check_command() {
    if ! command -v "$1" &> /dev/null; then
        echo -e "${RED}Error: $1 is not installed. Please install it first.${NC}"
        exit 1
    fi
}

# Function to log steps
log_step() {
    echo -e "${GREEN}[+] $1${NC}"
}

# Function to log info
log_info() {
    echo -e "${YELLOW}[i] $1${NC}"
}

# Print banner
echo -e "${BLUE}$BANNER${NC}"
echo -e "${BLUE}SWA Development Environment Installer${NC}"
echo -e "${YELLOW}This script will install JetBrains Toolbox App and configure prerequisites.${NC}"
echo

# Check for sudo access
if [[ $EUID -ne 0 ]] && ! sudo -v &>/dev/null; then
    echo -e "${RED}Error: This script requires sudo privileges for some operations.${NC}"
    exit 1
fi

# Check for required commands
check_command "wget"
check_command "tar"

# Install dependencies
log_step "Installing required dependencies"
sudo apt update
if ! sudo apt install -y libfuse2; then
    echo -e "${RED}Failed to install libfuse2. Please check your internet connection or apt repositories.${NC}"
    exit 1
fi
log_info "Dependencies installed successfully"

# Create temp directory
TEMP_DIR=$(mktemp -d)
log_info "Working in temporary directory: $TEMP_DIR"
cd "$TEMP_DIR" || exit 1

# Get latest version of Toolbox
log_step "Downloading JetBrains Toolbox App"
TOOLBOX_URL="https://data.services.jetbrains.com/products/download?platform=linux&code=TBA"
log_info "Fetching latest version from JetBrains servers..."

if ! wget -O jetbrains-toolbox.tar.gz "$TOOLBOX_URL"; then
    echo -e "${RED}Failed to download JetBrains Toolbox. Please check your internet connection.${NC}"
    rm -rf "$TEMP_DIR"
    exit 1
fi

# Extract the archive
log_step "Extracting JetBrains Toolbox App"
if ! tar -xzf jetbrains-toolbox.tar.gz; then
    echo -e "${RED}Failed to extract the Toolbox archive.${NC}"
    rm -rf "$TEMP_DIR"
    exit 1
fi

# Find the extracted directory
TOOLBOX_DIR=$(find . -maxdepth 1 -type d -name "jetbrains-toolbox-*" | head -n 1)
if [ -z "$TOOLBOX_DIR" ]; then
    echo -e "${RED}Could not find extracted Toolbox directory.${NC}"
    rm -rf "$TEMP_DIR"
    exit 1
fi

# Change to the directory and run the executable
log_step "Installing JetBrains Toolbox App"
cd "$TOOLBOX_DIR" || exit 1

# Check if Toolbox is already installed
TOOLBOX_INSTALL_PATH="$HOME/.local/share/JetBrains/Toolbox"
if [ -d "$TOOLBOX_INSTALL_PATH" ]; then
    log_info "JetBrains Toolbox is already installed at $TOOLBOX_INSTALL_PATH"
    log_info "Launching existing installation..."
    "$TOOLBOX_INSTALL_PATH/bin/jetbrains-toolbox" &
else
    log_info "Running Toolbox installer..."
    # Execute the installer and send to background
    ./jetbrains-toolbox &
    
    # Wait for the installation process to start
    sleep 2
    log_info "Toolbox App is being installed to $HOME/.local/share/JetBrains/Toolbox"
    log_info "The installer will continue in the background"
fi

# Cleanup
log_step "Cleaning up temporary files"
cd "$HOME" || exit 1
rm -rf "$TEMP_DIR"

# Final instructions
echo
echo -e "${GREEN}=== Installation Complete ===${NC}"
echo -e "${YELLOW}JetBrains Toolbox App has been installed and started in the background.${NC}"
echo -e "${YELLOW}You can access it from your system tray or application menu.${NC}"
echo
echo -e "${BLUE}Next steps:${NC}"
echo -e "${YELLOW}1. Log in to your JetBrains Account from the Toolbox App${NC}"
echo -e "${YELLOW}2. Install IntelliJ IDEA or other JetBrains products${NC}"
echo -e "${YELLOW}3. Toolbox will automatically activate available licenses${NC}"
echo
echo -e "${GREEN}Happy coding!${NC}"
