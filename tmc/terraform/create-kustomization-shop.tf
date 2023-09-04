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
    labels      = { "key" : "value" }
  }

  spec {
    path             = "microservices-demo/kustomize" # Required
    prune            = false
    interval         = "1m" # Default: 5m
    target_namespace = "shop"
    source {
      name      = "github-viktorious-microservices"      # Required
      namespace = "tanzu-continuousdelivery-resources" # Required
    }
  }
}