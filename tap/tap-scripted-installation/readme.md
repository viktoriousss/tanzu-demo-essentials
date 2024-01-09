# Deployment flow

Prerequisites: https://www.viktorious.nl/2022/11/11/scripted-installation-of-tanzu-application-platform#prereq/

Also make sure you have Helm available on your system.

# Setup environment variables and install Tanzu CLI
First steps, configuring some prerequisites. Edit 00-set-environment-variables.sh so it reflects the settings for your environment.
```bash
# Read variables - required for the other scripts to work
source 00-set-environment-variables.sh

# Removal of Tanzu CLI - only if a previous version of Tanzu CLI is installed on your system.
# Be careful if you have Tanzu CLI installed to manage existing TKGs/TKGm environment.
./01-remove-tanzu-cli.sh

# Install Tanzu CLI - only if Tanzu CLI is not available on your system.
# Will install TAP specific plugins
./02-install-tanzu-cli.sh
```

# Prepare Kubernetes environment, registry and deploy database
Kubernetes cluster should be available at this time. You should also have a private registry available. Helm is also required.
```bash
# Deploy cluster essentials on K8S cluster (not required for TKGm and TKGs on vSphere 8, required for TKGs on vSphere 7 and other K8S distributions)
./03-deploy-cluster-essentials.sh

# Relocate images to your private registry. Not required if you use script 05b-add-repo-to-cluster.
./04-relocate-images-to-registry.sh

# Add repo to the cluster using the relocated images from your private registry. Not required if you use script 05b-add-repo-to-cluster.
./05-add-repo-to-cluster.sh

# Add the repo directly from Tanzu Net registry. Not advised for production, because Tanzu Net registry doesn't have an SLA. Skip scripts 04 & 05.
./05b-add-repo-to-cluster.sh

# Install database (if there's already a database available you might want to skip this) using Helm.
./06-install-database.sh
```

# Install Tanzu Application Platform
Script 07-install-tap.sh installs TAP using tap-values.yaml for configuration of TAP.



```bash
# Install TAP (finally)
./07-install-tap.sh

# Configure TLS certificates for tap-gui
./08-tap-configure-tls-and-secrets.sh
```

# Maintenance scripts
```bash
# Monitor TAP installation progress
./97-monitor-tap-installation

# Run this script after an update to tap-values.yaml
./98-update-tap.sh

# Run this script to remove TAP
/99-remove-tap.sh
```