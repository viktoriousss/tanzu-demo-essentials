# Create certificate for tap-gui

Create a secret for Route53 access

```bash
kubectl create secret generic route53-credentials-secret --from-file=password.txt -n cert-manager
```
Create a Route53 based cluster issuer

```bash
kubectl apply -f route53-clusterissuer.yaml
```

Create the TAP GUI certificate

```bash
kubectl apply -f tap-gui-certificate.yaml
```