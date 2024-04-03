#!/bin/sh

# Switch off swap - also update /etc/fstab
sudo swapoff -a

# Configure overlay + br_netfilter
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF
sudo modprobe overlay
sudo modprobe br_netfilter

# sysctl params required by setup, params persist across reboots
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF
sudo sysctl --system

# Setup the repository
sudo apt-get install -y apt-transport-https ca-certificates curl
sudo mkdir /etc/apt/keyrings
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /" | sudo tee /etc/apt/sources.list.d/kubernetes.list
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
sudo apt-get update
sudo apt-get upgrade

# Download images
sudo kubeadm config images pull

# Initially Kubernetes cluster
sudo kubeadm init --pod-network-cidr=10.10.0.0/16 --skip-phases=addon/kube-proxy

# Get kubeconfig
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
sudo systemctl restart containerd

# Install helm + add Cilium repo
sudo snap install helm --classic
helm repo add cilium https://helm.cilium.io/
helm install cilium cilium/cilium --version 1.15.3   --namespace kube-system

# Install Cilium CLI
CILIUM_CLI_VERSION=$(curl -s https://raw.githubusercontent.com/cilium/cilium-cli/main/stable.txt)
CLI_ARCH=amd64
if [ "$(uname -m)" = "aarch64" ]; then CLI_ARCH=arm64; fi
curl -L --fail --remote-name-all https://github.com/cilium/cilium-cli/releases/download/${CILIUM_CLI_VERSION}/cilium-linux-${CLI_ARCH}.tar.gz{,.sha256sum}
sha256sum --check cilium-linux-${CLI_ARCH}.tar.gz.sha256sum
sudo tar xzvfC cilium-linux-${CLI_ARCH}.tar.gz /usr/local/bin
rm cilium-linux-${CLI_ARCH}.tar.gz{,.sha256sum}

# Retrieve Kubeadm token to add additional worker node
sudo kubeadm token create --print-join-command

# Setup cilium

# Create BGP policy
kubectl apply -f cilium-bgp-policy.yaml

# Add label to all worker nodes (label is defined in cilium-bgp-policy.yaml)
kubectl label nodes worker01 bgp-policy=lb

# Add the two LB pools
kubectl apply -f cilium-lb-ip-pool.yaml
kubectl apply -f cilium-lb-ip-pool-with-selector.yaml

# Optional: add hubble-svc if required
kubectl apply -f hubble-svc.yaml
