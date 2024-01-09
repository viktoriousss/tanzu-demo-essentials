# 07-install-database.sh
#
# Run this script in the context of the Kubernetes cluster you're installing TAP to.
# Use kubectl config set-context to switch to correct cluster prior to running this script.
#

# Install Postgresql for TAP GUI persistence
#

kubectl create ns $POSTGRES_NAMESPACE
helm repo add bitnami https://charts.bitnami.com/bitnami
helm install postgresql bitnami/postgresql -n "$POSTGRES_NAMESPACE" --set global.postgresql.auth.postgresPassword="$POSTGRES_ADMIN_PASSWORD" --set global.postgresql.auth.username="$POSTGRES_USERNAME" --set global.postgresql.auth.password="$POSTGRES_PASSWORD"
