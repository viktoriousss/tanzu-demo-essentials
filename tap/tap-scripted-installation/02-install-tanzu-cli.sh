#!/bin/bash
#
# 02-instal-tanzu-cli.sh
#
# This bash script runs on MacOS, Linux and Windows (using "bash 02-install-tanzu-cli.sh").
#

echo "Welcome to the Tanzu CLI installation"

while true; do
    echo "Choose your Tanzu CLI installation option"
    echo "1. Brew (MacOS/Linux)"
    echo "2. Chocolatey (Windows)"
    echo "3. APT (Debian/Ubuntu)"
    echo "4. YUM (RedHat)"
    echo "5. Binary download (Linux)"
    echo "6. Binary download (MacOS)"
    echo "9. Exit"

    read -p "Enter your choice (1-6 or 9): " choice

    case $choice in
        1)
            # Option 1: Brew
            echo "Installing via Brew..."
            brew update
            brew install vmware-tanzu/tanzu/tanzu-cli
            echo "Command: brew install vmware-tanzu/tanzu/tanzu-cli"
            ;;
        2)
            # Option 2: Choco
            echo "Installing example_software from Source Code..."
            choco install tanzu-cli
            echo "Command: choco install tanzu-cli"
            ;;
        3)
            # Option 3: Install from a Binary Release
            echo "Installing via APT"
            sudo mkdir -p /etc/apt/keyrings/
            sudo apt-get update
            sudo apt-get install -y ca-certificates curl gpg
            curl -fsSL https://packages.vmware.com/tools/keys/VMWARE-PACKAGING-GPG-RSA-KEY.pub | sudo gpg --dearmor -o /etc/apt/keyrings/tanzu-archive-keyring.gpg
            echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/tanzu-archive-keyring.gpg] https://storage.googleapis.com/tanzu-cli-os-packages/apt tanzu-cli-jessie main" | sudo tee /etc/apt/sources.list.d/tanzu.list
            sudo apt-get update
            sudo apt-get install -y tanzu-cli            
            ;;
        4)
            # Option 4: YUM
            echo "Installing via YUM"
            cat << EOF
sudo tee /etc/yum.repos.d/tanzu-cli.repo
[tanzu-cli]
name=Tanzu CLI
baseurl=https://storage.googleapis.com/tanzu-cli-os-packages/rpm/tanzu-cli
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.vmware.com/tools/keys/VMWARE-PACKAGING-GPG-RSA-KEY.pub
EOF
            sudo yum install -y tanzu-cli # If you are using DNF, run sudo dnf install -y tanzu-cli.
            ;;
       
       5)
            # Option 5: Binary download
            echo "Installing binary download Linux"
            # $TANZU_CLI_FILE - this variable should be set in 00-set-environment-variables.sh
            tar -xvf $TANZU_CLI_FILE
            sudo install tanzu-cli-linux_amd64 /usr/local/bin/tanzu
            ;;

        6)
            # Option 5: Binary download
            echo "Installing binary download MacOS"
            # $TANZU_CLI_FILE - this variable should be set in 00-set-environment-variables.sh
            tar -xvf $TANZU_CLI_FILE
            install tanzu-cli-darwin_amd64 /usr/local/bin/tanzu
            ;;

        9)
            exit
            ;;

        *)
            # Invalid option
            echo "Invalid option. Please enter a number between 1 and 4."
            ;;
    esac
done