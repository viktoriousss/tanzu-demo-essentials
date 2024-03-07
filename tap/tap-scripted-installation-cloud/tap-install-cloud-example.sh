#!/bin/bash
#
# Set your environment variables
TANZU_NET_USER=""                                       # Useraccount for TanzuNet
TANZU_NET_PASSWORD=""                                   # Password for TanzuNet
INGRESS_DOMAIN="tap.cloud.viktoriouslab.nl"             # Your TAP environment is accesible at tap-gui.INGRESS_DOMAIN
REPOSITORY_NAME=tap-deliveries                          # GitHub Repository for K8S deployment artifacts
REPOSITORY_OWNER=viktoriousss                           # GitHub Repository login
CLIENTID=""                                             # You need to get this value from GitHub Developer Settings OAuth2 page
CLIENTSECRET=""                                         # You need to get this value from GitHub Developer Settings OAuth2 page

export TAP_VERSION="1.8.0"                              # TAP Version you're installing
export TAP_VALUES="tap-values-cloud.yaml"               # TAP values file you're using

# If using AWS you can set these values
# export AWS_ACCESS_KEY_ID=
# export AWS_SECRET_ACCESS_KEY=
# export AWS_SESSION_TOKEN=

# If you're using a pre-provisioned registry enter the details below. 
# If you're using the script to deploy a registry, leave these values empty
MY_REGISTRY=""
MY_REGISTRY_USER=""
MY_REGISTRY_PASSWORD=""

# Database settings for TAP-GUI persistence. You can leave it as it is.
# If you're changing this you need to manually update the tap-values.yaml file
POSTGRES_NAMESPACE="postgres"
POSTGRES_ADMIN_PASSWORD="VMware1!"
POSTGRES_USERNAME="admin"
POSTGRES_PASSWORD="VMware1!"

# Cluster essentials file - you have to download this file from https://network.tanzu.vmware.com/
# and put it in the same directory as this script. Linux file has a different filename
# Tanzu install bundle name is depending on Cluster Essentials version
#
TANZU_CLUSTER_ESSENTIALS_FILE=tanzu-cluster-essentials-darwin-amd64-1.8.0.tgz
TANZU_CLUSTER_ESSENTIALS_INSTALL_BUNDLE=registry.tanzu.vmware.com/tanzu-cluster-essentials/cluster-essentials-bundle@sha256:8b4c5b575a015c7490b67329b14e9ca160753b047ba411e937af0f6d317e1596

# First step - create a registry
echo "What kind of registry do you want to use?"

registryoptions=("Azure Registry" "Pre-provisioned")
select option in "${registryoptions[@]}"; do
    case $REPLY in
        1)
            echo "Deploying an Azure Registry and retrieving the details..."
            # Deploying an Azure Registry using Terraform
            az login
            terraform -chdir=azure-registry init
            terraform -chdir=azure-registry apply
                        
            # Get the registry details of the deployed Azure Registry
            MY_REGISTRY=$(terraform -chdir=azure-registry output -raw login_server)
            MY_REGISTRY_USER=$(terraform -chdir=azure-registry output -raw admin_username)
            MY_REGISTRY_PASSWORD=$(terraform -chdir=azure-registry output -raw admin_password)
            echo "Azure registry $MY_REGISTRY with login $MY_REGISTRY_USER created."
            break
            ;;
        2)
            echo "Use an existing registry, make sure you've added the details to the script"
            break
            ;;
         *) 
            echo "Invalid option. Please select a number between 1 and ${#options[@]}"
            ;;
    esac
done           

# Define the options for the menu
options=("AKS" "EKS" "GKE" "Current K8S-context")

# Print the menu
echo "Where do you want to install TAP:"

# Loop through the options array and display the menu
select option in "${options[@]}"; do
    case $REPLY in
        1) 
            echo "You selected: AKS"
            az login
            terraform -chdir=azure init
            terraform -chdir=azure apply                    
            az aks get-credentials --resource-group TAP --name tapaks01 --overwrite-existing
            break
            ;;
        2) 
            echo "You selected: EKS - work in progress, this option is not yet fully operational."
            echo "Press space bar to continue or ctrl-c to quit"

            # Read a single character from the user input
            read -n 1 key
            
            aws configure
            terraform -chdir=aws init
            terraform -chdir=aws apply                    
            aws eks update-kubeconfig --region eu-central-1 --name tapaks01
            break
            # Add your code for Option 2 here
            ;;
        3) 
            echo "You selected: GKE"            
            echo "Let's first logon to your environment, you need to have gcloud CLI installed"
            gcloud auth login
            #Now deploy a GKE cluster            
            terraform -chdir=google init
            terraform -chdir=google apply
            #Now add GKE cluster credentials to local kubeconfig, this command also changes to context to this new environment            
            gcloud container clusters get-credentials vvandenberg-proj-gke --region europe-west1-b --project vvandenberg-proj
            break
            ;;
        4)  echo "Installing in the current Kubernetes context"
            break
            ;;
        *) 
            echo "Invalid option. Please select a number between 1 and ${#options[@]}"
            ;;
    esac
done

# Install cluster essentials
mkdir ./tanzu-cluster-essentials
tar -xvf $TANZU_CLUSTER_ESSENTIALS_FILE -C ./tanzu-cluster-essentials
export INSTALL_BUNDLE=$TANZU_CLUSTER_ESSENTIALS_INSTALL_BUNDLE
export INSTALL_REGISTRY_HOSTNAME=registry.tanzu.vmware.com
export INSTALL_REGISTRY_USERNAME=$TANZU_NET_USER
export INSTALL_REGISTRY_PASSWORD=$TANZU_NET_PASSWORD
cd tanzu-cluster-essentials
./install.sh --yes
cd ..

# Add repository to cluster
kubectl create ns tap-install
tanzu secret registry add tap-registry \
    --server   ${MY_REGISTRY} \
    --username ${MY_REGISTRY_USER} \
    --password ${MY_REGISTRY_PASSWORD} \
    --namespace tap-install \
    --export-to-all-namespaces \
    --yes

tanzu secret registry add tanzunet-registry \
  --username ${TANZU_NET_USER} --password ${TANZU_NET_PASSWORD} \
  --server registry.tanzu.vmware.com\
  --export-to-all-namespaces --yes --namespace tap-install

tanzu package repository add tanzu-tap-repository \
  --url registry.tanzu.vmware.com/tanzu-application-platform/tap-packages:${TAP_VERSION} \
  --namespace tap-install

# Install and configure Postgresql database using helm
kubectl create ns $POSTGRES_NAMESPACE
helm repo add bitnami https://charts.bitnami.com/bitnami
helm install postgresql bitnami/postgresql -n "$POSTGRES_NAMESPACE" --set global.postgresql.auth.postgresPassword="$POSTGRES_ADMIN_PASSWORD" --set global.postgresql.auth.username="$POSTGRES_USERNAME" --set global.postgresql.auth.password="$POSTGRES_PASSWORD"

# Copy the tap-values.yaml.template to tap-values.yaml and set values
cp $TAP_VALUES.template $TAP_VALUES
sed -i "" "s/<INGRESS_DOMAIN>/$INGRESS_DOMAIN/g" $TAP_VALUES
sed -i "" "s/<MY_REGISTRY>/$MY_REGISTRY/g" $TAP_VALUES
sed -i "" "s/<REPOSITORY_OWNER>/$REPOSITORY_OWNER/g" $TAP_VALUES
sed -i "" "s/<REPOSITORY_NAME>/$REPOSITORY_NAME/g" $TAP_VALUES
sed -i "" "s/<CLIENTID>/$CLIENTID/g" $TAP_VALUES
sed -i "" "s/<CLIENTSECRET>/$CLIENTSECRET/g" $TAP_VALUES

# Create secret for GitHub access
kubectl apply -f ../secrets/git-secret.yaml

# Create required secrets for Local Source Proxy and set SecretExports
tanzu secret registry add lsp-pull-credentials --username $MY_REGISTRY_USER --password $MY_REGISTRY_PASSWORD --server $MY_REGISTRY --namespace tap-install --yes
tanzu secret registry add lsp-push-credentials --username $MY_REGISTRY_USER --password $MY_REGISTRY_PASSWORD --server $MY_REGISTRY --namespace tap-install --yes
kubectl apply -f ../secrets/lsp-secret-exports.yaml

# Install TAP
tanzu package install tap -p tap.tanzu.vmware.com -v $TAP_VERSION --values-file $TAP_VALUES -n tap-install

# Wait
echo "Please verify if all packages have been reconciled using: kubectl -n tap-install get packageinstalled"
echo "Press space bar to continue..."

# Read a single character from the user input
read -n 1 key

# TAP-GUI certificate generation using Let's Encrypt and AWS Route53
kubectl create secret generic route53-credentials-secret --from-file="../tls/password-viktorious.txt" -n cert-manager
kubectl apply -f ../tls/route53-clusterissuer-viktorious.yaml
kubectl apply -f ../tls/tap-gui-azure-certificate.yaml

# Now deploy some apps
tanzu apps workload create --yes -n ns-production -f https://raw.githubusercontent.com/viktoriousss/golang-demo/main/config/workload.yaml
tanzu apps workload create --yes -n ns-production -f https://raw.githubusercontent.com/viktoriousss/nl-tanzu-java-web-app/main/config/workload.yaml
tanzu service class-claim create customer-database --class postgresql-unmanaged -n ns-production
tanzu apps workload create --yes -n ns-production -f https://raw.githubusercontent.com/viktoriousss/nl-java-rest-service/main/config/workload.yaml

TAPIP=$(kubectl get service -n tanzu-system-ingress envoy -o jsonpath="{.status.loadBalancer.ingress[0].ip}")
echo "Now update your DNS and create a wildcard A record that points *.$INGRESS_DOMAIN to $TAPIP"