# 09-tap-configure-tls.sh
#
# First update password.txt and route53-clusterissuer.yaml
#
#
kubectl create secret generic route53-credentials-secret --from-file=./additional-configuration/tls/password.txt -n cert-manager
kubectl apply -f ./additional-configuration/tls/route53-clusterissuer.yaml
kubectl apply -f ./additional-configuration/tls/tap-gui-certificate.yaml