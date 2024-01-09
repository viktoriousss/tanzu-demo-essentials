# 05-add-repo-to-cluster.sh
#
# This scripts defines the repository to pull the images from the private registry and install them to the cluster.
#
# Run this script in the context of the Kubernetes cluster you're planning to install TAP on.
# Use 'kubectl config set-context <kubernetes context>' to switch to correct cluster prior to running this script.
#

kubectl create ns tap-install

# Create secret for private registry access
tanzu secret registry add tap-registry \
  --username ${MY_REGISTRY_USER} --password ${MY_REGISTRY_PASSWORD} \
  --server ${MY_REGISTRY} \
  --export-to-all-namespaces --yes --namespace tap-install

# Create repository
tanzu package repository add tanzu-tap-repository \
  --url ${MY_REGISTRY}/${MY_REGISTRY_INSTALL_REPO}/tap-packages:$TAP_VERSION \
  --namespace tap-install

# Check repository
tanzu package repository get tanzu-tap-repository --namespace tap-install

# List available packes
tanzu package available list --namespace tap-install