# Create Tanzu Mission Control namespace with attached set as default value.
resource "tanzu-mission-control_namespace" "shop" {
  name                    = var.tmc-target_namespace # Required
  cluster_name            = var.tmc-tkg_cluster_name  # Required
  provisioner_name        = var.tmc-provisioner_name     # Default: attached
  management_cluster_name = var.tmc-management_cluster_name     # Default: attached

  meta {
    description = "Create namespace through terraform"
    labels      = { "owner" : var.tmc-owner }
  }

  spec {
    workspace_name = "viktorious-workspace" # Default: default
    attach         = false     # Default: false
  }
  depends_on = [ tanzu-mission-control_cluster.create_tkgs_workload ]
}