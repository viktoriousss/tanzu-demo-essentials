/*
Cluster group scoped Tanzu Mission Control security policy with a strict input recipe.
This policy is applied to a cluster group with the strict configuration option and is inherited by the clusters.
The defined scope and input blocks can be updated to change the policy's scope and recipe.
*/
resource "tanzu-mission-control_security_policy" "no-strict-psp" {
  name = "no-strict-psp"

  scope {
    cluster_group {
      cluster_group = var.tmc-cluster_group
    }
  }

  spec {
    input {
      baseline {
        audit              = true
        disable_native_psp = true
      }
    }
  }
  depends_on = [ tanzu-mission-control_cluster_group.viktorious-tf ]
}