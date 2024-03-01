#!/bin/bash
#
# Set your environment variables
TANZU_NET_USER=""                 # Useraccount for TanzuNet
TANZU_NET_PASSWORD=""                     # Password for TanzuNet
INGRESS_DOMAIN="tap.azure.viktoriouslab.nl"             # Your TAP environment is accesible at tap-gui.INGRESS_DOMAIN
REPOSITORY_NAME=tap-deliveries                          # GitHub Repository for K8S deployment artifacts
REPOSITORY_OWNER=viktoriousss                           # GitHub Repository login
CLIENTID=""                         # You need to get this value from GitHub Developer Settings OAuth2 page
CLIENTSECRET="" # You need to get this value from GitHub Developer Settings OAuth2 page

export TAP_VERSION="1.7.3"                              # TAP Version you're installing
export TAP_VALUES="tap-values-cloud.yaml"               # TAP values file you're using

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
TANZU_CLUSTER_ESSENTIALS_FILE=tanzu-cluster-essentials-darwin-amd64-1.7.3.tgz
TANZU_CLUSTER_ESSENTIALS_INSTALL_BUNDLE=registry.tanzu.vmware.com/tanzu-cluster-essentials/cluster-essentials-bundle@sha256:14ad1780516c7d96ee9a8201b69dc8332b18bbfcdfc71762e7583ded3723c2dd

# Define the options for the menu
options=("AKS" "EKS" "GKE")

# Print the menu
echo "Where do you want to install TAP:"

# Loop through the options array and display the menu
select option in "${options[@]}"; do
    case $REPLY in
        1) 
            echo "You selected: AKS"
            terraform -chdir=azure init
            terraform -chdir=azure apply
            terraform -chdir=azure output -raw kube_config > kubeconfig-tapaks
            CURRENTPATH=$(pwd)
            export KUBECONFIG=~/.kube/config:$CURRENTPATH/kubeconfig-tapaks
            kubectx tapaks01
            break
            ;;
        2) 
            echo "You selected: EKS - to be implemented"
            # Add your code for Option 2 here
            ;;
        3) 
            echo "You selected: GKE"
            #First deploy an Azure Registry (google registry not yet implemented)
            terraform -chdir=azure-registry init
            terraform -chdir=azure-registry apply
            #Now deploy a GKE cluster
            terraform -chdir=google init
            terraform -chdir=google apply
            #Now add GKE cluster credentials to local kubeconfig, this command also changes to context to this new environment
            gcloud container clusters get-credentials vvandenberg-proj-gke --region europe-west1 --project vvandenberg-proj
            break
            ;;
        *) 
            echo "Invalid option. Please select a number between 1 and ${#options[@]}"
            ;;
    esac
done

# Get the registry details of the deployed Azure Registry
MY_REGISTRY=$(terraform -chdir=azure-registry output -raw login_server)
MY_REGISTRY_USER=$(terraform -chdir=azure-registry output -raw admin_username)
MY_REGISTRY_PASSWORD=$(terraform -chdir=azure-registry output -raw admin_password)


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

# Update TAP values file
cp $TAP_VALUES $TAP_VALUES.backup
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
echo "Press space bar to continue..."

# Read a single character from the user input
read -n 1 key

# TAP-GUI certificate generation using Let's Encrypt and AWS Route53
kubectl create secret generic route53-credentials-secret --from-file=../tls/password-viktorious.txt -n cert-manager
kubectl apply -f ../tls/route53-clusterissuer-viktorious.yaml
kubectl apply -f ../tls/tap-gui-azure-certificate.yaml

# Now deploy some apps
tanzu apps workload create --yes -n ns-production -f https://raw.githubusercontent.com/viktoriousss/golang-demo/main/config/workload.yaml
tanzu apps workload create --yes -n ns-production -f https://raw.githubusercontent.com/viktoriousss/nl-tanzu-java-web-app/main/config/workload.yaml
tanzu service class-claim create customer-database --class postgresql-unmanaged -n ns-production
tanzu apps workload create --yes -n ns-production -f https://raw.githubusercontent.com/viktoriousss/nl-java-rest-service/main/config/workload.yaml

TAPIP=$(kubectl get service -n tanzu-system-ingress envoy -o jsonpath="{.status.loadBalancer.ingress[0].ip}")
echo "Now update your DNS and create a wildcard A record that points *.$INGRESS_DOMAIN to $TAPIP"