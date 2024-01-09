# 03-relocate-images-to-private-registry.sh
#
# This scripts relocates files from Tanzu network registry to your private registry.
#
# You can skip this step if you're deploying TAP directly from the Tanzu Network registry.
# In that case run script 05b-add-repo-to-cluster.sh after this script and skip 05-add-repo-to-cluster.sh.
#
echo "Login in to registry '$MY_REGISTRY'"
docker login $MY_REGISTRY --username $MY_REGISTRY_USER --password $MY_REGISTRY_PASSWORD
echo "Login in to registry 'registry.tanzu.vmware.com'"
docker login registry.tanzu.vmware.com --username $TANZU_NET_USER --password $TANZU_NET_PASSWORD
echo "Copying files from registry.tanzu.vmware.com to repo '$MY_REGISTRY_INSTALL_REPO' on registry '$MY_REGISTRY'"
imgpkg copy -b registry.tanzu.vmware.com/tanzu-application-platform/tap-packages:${TAP_VERSION} --to-repo ${MY_REGISTRY}/${MY_REGISTRY_INSTALL_REPO}/tap-packages --include-non-distributable-layers