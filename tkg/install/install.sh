#
# TKG prerequisites installation script that works for Ubuntu 22.04.2
#

read -p "Do you want to install Docker? Choose n if you've already installed Docker (y/n) " choice

# Check user's response, install & configure docker and reboot or continue with script
if [[ $choice =~ ^[Yy]$ ]]; then
    echo "Installing docker..."
    sudo snap install docker
    sudo groupadd docker
    sudo usermod -aG docker $USER
    sudo reboot
    echo "Now rebooting, wait 2 minutes then reconnect"
else
    echo "Continuing with remaining steps of the script..."
    # Add remaining steps of the script here
fi

#
# Test docker
#
# Optional - login to dockerhub if you face download rate limiting: 

# docker login --username <USERNAME>

# Test docker

docker run hello-world

#
# Required configuration for Kind used by TKG installer
#

sudo sysctl net/netfilter/nf_conntrack_max=131072

#
# Install and configure Tanzu CLI
#

sudo apt update
sudo apt install -y ca-certificates curl gpg
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://packages.vmware.com/tools/keys/VMWARE-PACKAGING-GPG-RSA-KEY.pub | sudo gpg --dearmor -o /etc/apt/keyrings/tanzu-archive-keyring.gpg
echo "deb [signed-by=/etc/apt/keyrings/tanzu-archive-keyring.gpg] https://storage.googleapis.com/tanzu-cli-os-packages/apt tanzu-cli-jessie main" | sudo tee /etc/apt/sources.list.d/tanzu.list
sudo apt update
sudo apt install -y tanzu-cli

tanzu init
tanzu version

#
# Install brew package manager
#

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
(echo; echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"') >> /home/viktor/.profile
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

#
# Install Kubernetes tooling
#

brew install kubectl kubectx kube-ps1 yq git

alias k=kubectl
echo "alias k=kubectl" >>  ~/.bashrc

#
# Autocompletion stuff and setting the prompt
#

source <(/home/linuxbrew/.linuxbrew/bin/kubectl completion bash)
echo "source <(/home/linuxbrew/.linuxbrew/bin/kubectl completion bash)" >> ~/.bashrc

complete -F __start_kubectl k
echo "complete -F __start_kubectl k" >> ~/.bashrc

source "/home/linuxbrew/.linuxbrew/opt/kube-ps1/share/kube-ps1.sh"
echo "source \"/home/linuxbrew/.linuxbrew/opt/kube-ps1/share/kube-ps1.sh\"" >> ~/.bashrc

PS1='$(kube_ps1) '$PS1
echo "PS1='\$(kube_ps1) '\$PS1"

#Install Carvel tools

brew tap vmware-tanzu/carvel
brew install ytt kbld kapp imgpkg kwt vendir kctrl
