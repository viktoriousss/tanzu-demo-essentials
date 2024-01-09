# 10-remove-tap.sh
#
# This scripts removes TAP from your Kubernetes cluster
#
# Run this script in the context of the Kubernetes cluster TAP is running on.
# Use kubectl config set-context to switch to correct cluster prior to running this script.
#
# Remove TAP
#

tanzu package installed delete tap -n tap-install