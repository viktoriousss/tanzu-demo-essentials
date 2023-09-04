# TKG
Contains some files mainly to be used for vSphere /w Tanzu (TKGs).

## File/folder Structure
* login.sh - can be used to logon to a vSphere with Tanzu environment including available TKG workload clusters.
* tkg01.yaml - example Cluster API (CAPI) file. Creates a new cluster, to be executed in the context of your supervisor cluster.
* tkg01-with-extra-storage.yaml - Same as the previous one, adds additional (local) storage to the cluster nodes.
