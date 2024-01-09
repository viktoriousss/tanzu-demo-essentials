#
# First set a few environment variables
# Change it to your own username/psw
#

export POSTGRES_NAMESPACE="postgres"
export POSTGRES_ADMIN_PASSWORD="VMware1\!"
export POSTGRES_USERNAME="admin"
export POSTGRES_PASSWORD="VMware1\!"

#
# Add the Bitnami Helm repository and install Postgres
#

helm repo add bitnami https://charts.bitnami.com/bitnami
helm install postgresql bitnami/postgresql -n "$POSTGRES_NAMESPACE" --set global.postgresql.auth.postgresPassword="$POSTGRES_ADMIN_PASSWORD" --set global.postgresql.auth.username="$POSTGRES_USERNAME" --set global.postgresql.auth.password="$POSTGRES_PASSWORD"

# PostgreSQL can be accessed via port 5432 on the following DNS names from within your cluster:
#
#    postgresql.postgres.svc.cluster.local - Read/Write connection
#
# To get the password for "postgres" run:
#
#    export POSTGRES_ADMIN_PASSWORD=$(kubectl get secret --namespace postgres postgresql -o jsonpath="{.data.postgres-password}" | base64 -d)
#
# To get the password for "admin" run:
#
#    export POSTGRES_PASSWORD=$(kubectl get secret --namespace postgres postgresql -o jsonpath="{.data.password}" | base64 -d)
#
# To connect to your database run the following command:
#
#    kubectl run postgresql-client --rm --tty -i --restart='Never' --namespace postgres --image docker.io/bitnami/postgresql:16.0.0-debian-11-r10 --env="PGPASSWORD=$POSTGRES_PASSWORD" --command -- psql --host postgresql -U admin -d postgres -p 5432
#
#    > NOTE: If you access the container using bash, make sure that you execute "/opt/bitnami/scripts/postgresql/entrypoint.sh /bin/bash" in order to avoid the error "psql: local user with ID 1001} does not exist"
#
# To connect to your database from outside the cluster execute the following commands:
#
#    kubectl port-forward --namespace postgres svc/postgresql 5432:5432 &
#    PGPASSWORD="$POSTGRES_PASSWORD" psql --host 127.0.0.1 -U admin -d postgres -p 5432