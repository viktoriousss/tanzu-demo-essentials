This is an example Terraform configuration using the provider for Tanzu Mission Control

More information here: https://registry.terraform.io/providers/vmware/tanzu-mission-control/latest/docs

It will create:
- A cluster group
- A policy attached to the cluster group
- Two git repositories attached to the cluster group
- And kustomization attached to the cluster group
- Deploy a TKG cluster to vSphere /w Tanzu (v7 only as of now)
