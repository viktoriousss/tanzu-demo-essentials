The script tap-install-cloud-example.sh allows you deploy TAP to any (public) cloud. Configuration scripts for AKS/EKS/GKE are included, although EKS is still work-in-progress.

Edit tap-install-cloud-example.sh and add the configuration values for your environment. Also check tap-values-cloud.yaml.template.

For the script to work you will need:
* aws (AWS CLI)
* az (Azure CLI)
* gcloud (Google Cloud CLI)
* helm
* kubectl
* sed
* Tanzu CLI

You will need access to:
* One of the public clouds (Amazon, Azure, Google) or a pre-provisioned K8S cluster and registry
* Tanzu Net

Script is tested on MacOS but will probably also work on Linux (after some minor adjustments)