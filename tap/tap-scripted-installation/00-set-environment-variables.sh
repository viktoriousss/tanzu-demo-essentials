# 00-set-environment-variables.sh
#
# Run this script by running "source 00-set-environment-variables.sh"
#

# Tanzunet loging credentials
#
export TANZU_NET_USER=<Tanzu Network Email Address>
export TANZU_NET_PASSWORD=<Tanzu Network Password>

# Private registry details, used for TAP installation and storing container images
#
export MY_REGISTRY=<Private registry URL - e.g. registry.azurecr.io>
export MY_REGISTRY_USER=<Private registry login>
export MY_REGISTRY_PASSWORD=<Private registry password>

# Name of repository where you want to store TAP installation files
export MY_REGISTRY_INSTALL_REPO=tap-install

# Set iterate & developer namespace-names
#
export ITERATE_NAMESPACE=tap-iterate
export PRODUCTION_NAMESPACE=tap-production

# Set postgresql DB parameters. Database is used for persistence in TAP
#
export POSTGRESNAMESPACE=<kubernetes namespace to install postgresql to>
export POSTGRESPASSWORD=<password for the postgres admin user>
export POSTGRESUSERNAME=<username for another user>
export POSTGRESUSERPASSWORD=<password for another user>

# --------------------- Only configure this part if required ---------------------
#
# Only add the next lines if you're using the supply_chain: testing or testing_scanning setting in tap-values.yaml
#
# By default Tekton (used for testing) will pull test images from dockerhub. If you're using another registry for this, access to Dockerhub is not required.
# The Dockerhub account is required for solving rate-limiting issues: https://docs.docker.com/docker-hub/download-rate-limit/ (if applicable)
#
export $DOCKERHUB_USER=<Dockerhub Username>
export $DOCKERHUB_PASSWORD=<Dockerhub Password>
export $DOCKERHUB_EMAIL=<Dockerhub email-address linked to the username>

# --------------------- Version specific TAP installation parameters below here ---------------------
#
# Either 1.3.0, 1.3.1, 1.3.2, 1.3.3, 1.3.4, 1.4.0 or 1.5.0
#
# Parameters for TAP 1.4 are configured
#
export TAP_VERSION=1.5.0

# Tanzu CLI TAR file - you have to download this file from https://network.tanzu.vmware.com/
# 1.3.x: tanzu-framework-darwin-amd64.tar
# 1.4.0: tanzu-framework-darwin-amd64-v0.25.4.1.tar
# 1.5.0: tanzu-framework-darwin-amd64-v0.28.1.1.tar
#
export TANZU_CLI_FILE=tanzu-framework-darwin-amd64-v0.28.1.1.tar

# Tanzu CLI version - you have to download this file from https://network.pivotal.io/
#
# MacOS:
# 1.3.x: v0.25.0/tanzu-core-darwin_amd64
# 1.4.x: v0.25.4/tanzu-core-darwin_amd64
# 1.5.x: v0.28.1/tanzu-core-darwin_amd64
#
# Linux:
# 1.3.x: v0.25.0/tanzu-core-linux_amd64
# 1.4.x: v0.25.4/tanzu-core-linux_amd64
# 1.5.x: v0.28.1/tanzu-core-linux_amd64
#
export TANZU_CLI_VERSION=v0.28.1/tanzu-core-darwin_amd64

# Cluster essentials file - you have to download this file from https://network.tanzu.vmware.com/
# MacOS:
# 1.3.x: tanzu-framework-darwin-amd64.tgz
# 1.4.0: tanzu-framework-darwin-amd64-v0.25.4.1.tgz
# 1.5.0: tanzu-cluster-essentials-darwin-amd64-1.5.0.tgz
#
# Linux:
# 1.5.0: tanzu-cluster-essentials-linux-amd64-1.5.0.tgz
#
export TANZU_CLUSTER_ESSENTIALS_FILE=tanzu-cluster-essentials-darwin-amd64-1.5.0.tgz

# Cluster essentials install bundle - this file is available on registry.tanzu.vmware.com
# 1.3.x: registry.tanzu.vmware.com/tanzu-cluster-essentials/cluster-essentials-bundle@sha256:54bf611711923dccd7c7f10603c846782b90644d48f1cb570b43a082d18e23b9
# 1.4.0: registry.tanzu.vmware.com/tanzu-cluster-essentials/cluster-essentials-bundle@sha256:5fd527dda8af0e4c25c427e5659559a2ff9b283f6655a335ae08357ff63b8e7f
# 1.5.0: registry.tanzu.vmware.com/tanzu-cluster-essentials/cluster-essentials-bundle@sha256:79abddbc3b49b44fc368fede0dab93c266ff7c1fe305e2d555ed52d00361b446
#
export TANZU_CLUSTER_ESSENTIALS_INSTALL_BUNDLE=registry.tanzu.vmware.com/tanzu-cluster-essentials/cluster-essentials-bundle@sha256:79abddbc3b49b44fc368fede0dab93c266ff7c1fe305e2d555ed52d00361b446