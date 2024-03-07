The script tap-install-cloud-example.sh allows you deploy TAP to any (public) cloud or a pre-provisioned K8S cluster + registry. Configuration scripts for AKS/EKS/GKE are included, although EKS is still work-in-progress.

Fork and clone the repository for your convenience. Edit tap-install-cloud-example.sh and add the configuration values for your environment. Also check tap-values-cloud.yaml.template.

For the script to work you will need:
* aws (AWS CLI)
* az (Azure CLI)
* gcloud (Google Cloud CLI)
* git
* helm
* kubectl
* sed
* terraform (OpenTofu will probably also work)
* Tanzu CLI

You will need access to:
* One of the public clouds (Amazon, Azure, Google) or a pre-provisioned K8S cluster and registry
* Tanzu Net

Script is tested on MacOS but will probably also work on Linux (after some minor adjustments). 

To do:
* Currently the script only supports automated deployment of an registry running on Azure.
* Note that deployment to EKS is not yet fully operational and work-in-progress.