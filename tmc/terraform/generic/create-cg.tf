// Create cluster group
resource "tanzu-mission-control_cluster_group" "viktorious-tf" {
  name = var.tmc-cluster_group
  meta {
    description = "Cluster group through terraform"
    labels = {
      "owner" : var.tmc-owner
    }
  }
}