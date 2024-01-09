# 97-monitor-tap-installation
#
# This scripts monitors the installation of TAP.
#
# Run this script in the context of the Kubernetes cluster you're installing TAP to.
# Use kubectl config set-context to switch to correct cluster prior to running this script.
#

# Monitor TAP installation
#
kubectl get packageinstalls.packaging.carvel.dev -n tap-install -w