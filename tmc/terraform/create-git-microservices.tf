# Create Tanzu Mission Control git repository with attached set as default value.
resource "tanzu-mission-control_git_repository" "github-viktorious-microservices" {
  name = "github-viktorious-microservices" # Required

  namespace_name = "tanzu-continuousdelivery-resources" #Required

  scope {
    cluster_group {
      name = var.tmc-cluster_group # Required
    }
  }

  meta {
    description = "GIT repo created by Terraform"
    labels      = { "owner" : var.tmc-owner }
  }

  spec {
    url                = "https://github.com/viktoriousss/microservices-demo.git" # Required
    secret_ref         = ""
    interval           = "1m"    # Default: 5m
    git_implementation = "GO_GIT" # Default: GO_GIT
    #ref {
    #  branch = ""
    #  tag    = ""
    #  semver = ""
    #  commit = ""
    #}
  }
  depends_on = [ tanzu-mission-control_cluster_group.viktorious-tf ]
}