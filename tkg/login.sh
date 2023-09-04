#!/bin/bash
VCENTER_USERNAME="<vcenter-user-that-has-permissions-on-mangement-cluster-and-or-tkg-cluster(s)>" 
VCENTER_WCP_NAME="<your-vcenter-wcp-address>"

# Comma separated list of tkg workload-clusters, e.g. tkg01 tkg02
TKG_CLUSTERS=( "tkg01 tkg02" )

# Namespace where these clusters live (script currently only supports one namespace)
VSPHERE_NS="ns01"

# Set password - note, the password is set as an environment variable
export KUBECTL_VSPHERE_PASSWORD="<password-of-username-vcenter-user-that-has-permissions-on-mangement-cluster-and-or-tkg-cluster(s)"

#logon to supervisor cluster
kubectl vsphere login --server=$VCENTER_WCP_NAME --vsphere-username=$VCENTER_USERNAME --insecure-skip-tls-verify

#logon to TKG guest cluster(s)
for cluster in "${TKG_CLUSTERS[@]}"
do
   :
   kubectl vsphere login --server=$VCENTER_WCP_NAME --vsphere-username=$VCENTER_USERNAME --insecure-skip-tls-verify --tanzu-kubernetes-cluster-namespace $VSPHERE_NS --tanzu-kubernetes-cluster-name $cluster
done
