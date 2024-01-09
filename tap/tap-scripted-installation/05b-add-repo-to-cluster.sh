# 05b-add-repo-to-cluster.sh
#
# This scripts defines the repository to pull the images from the Tanzu Network registry and install them to the cluster.
# This is an option but not suggested for production environments because there's no SLA on the Tanzu Network registry
#
# Run this script in the context of the Kubernetes cluster you're planning to install TAP on.
# Use kubectl config set-context to switch to correct cluster prior to running this script.
#
# Either run script 05-add-repo-to-cluster.sh or script 05b-add-repo-to-cluster.sh!

kubectl create ns tap-install

# Create secret for private registry access
tanzu secret registry add tap-registry \
  --username ${TANZU_NET_USER} --password ${TANZU_NET_PASSWORD} \
  --server registry.tanzu.vmware.com\
  --export-to-all-namespaces --yes --namespace tap-install

# Create repository
tanzu package repository add tanzu-tap-repository \
  --url registry.tanzu.vmware.com/tanzu-application-platform/tap-packages:${TAP_VERSION} \
  --namespace tap-install

# Check repository
tanzu package repository get tanzu-tap-repository --namespace tap-install

# List available packes
tanzu package available list --namespace tap-install