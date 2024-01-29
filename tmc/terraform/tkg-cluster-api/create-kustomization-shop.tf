# Create Tanzu Mission Control kustomization with attached set as default value.
resource "tanzu-mission-control_kustomization" "microservices-demo" {
  name = "microservices-demo" # Required

  namespace_name = "tanzu-continuousdelivery-resources" #Required

  scope {
    cluster_group {
      name = var.tmc-cluster_group # Required
    }
  }

  meta {
    description = "Kustomization created by Terraform"
    labels      = { "owner" : var.tmc-owner }
  }

  spec {
    path             = "kustomize" # Required
    prune            = false
    interval         = "1m" # Default: 5m
    target_namespace = var.tmc-target_namespace
    source {
      name      = "github-viktorious-microservices"      # Required
      namespace = "tanzu-continuousdelivery-resources" # Required
    }
  }
  depends_on = [ tanzu-mission-control_cluster.create_tkgs_workload ]
}