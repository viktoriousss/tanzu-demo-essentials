# 09-tap-configure-tls.sh
#
# First update password.txt and route53-clusterissuer.yaml
#
#
kubectl create secret generic route53-credentials-secret --from-file=../tls/password.txt -n cert-manager
kubectl apply -f ../tls/route53-clusterissuer.yaml
kubectl apply -f ../tls/tap-gui-azure-certificate.yaml
kubectl apply -f ../secrets/git-secret.yaml