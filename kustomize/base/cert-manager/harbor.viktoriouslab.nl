apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  namespace: cert-manager
  name: harbor.viktoriouslab.nl
spec:
  commonName: harbor.viktoriouslab.nl
  dnsNames:
    - harbor.viktoriouslab.nl
  issuerRef:
    name: letsencrypt-route53
    kind: ClusterIssuer
  secretName: harbor.viktoriouslab.nl
