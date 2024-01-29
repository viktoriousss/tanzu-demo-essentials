# Create Tanzu Mission Control Tanzu Kubernetes Grid Service workload cluster entry
resource "tanzu-mission-control_tanzu_kubernetes_cluster" "tkgs_cluster" {
  name                    = var.tmc-tkg_cluster_name
  management_cluster_name = var.tmc-management_cluster_name
  provisioner_name        = var.tmc-provisioner_name

  spec {
    cluster_group_name = var.tmc-cluster_group_name

    topology {
      version           = var.tmc-kubernetes_version
      cluster_class     = "tanzukubernetescluster"
      cluster_variables = jsonencode(local.tkgs_cluster_variables)

      control_plane {
        replicas = var.tmc-control_plane_replicas

        os_image {
          name    = "photon"
          version = "3"
          arch    = "amd64"
        }
      }

      nodepool {
        name        = "md-0"
        description = "simple small md"

        spec {
          worker_class = "node-pool"
          replicas     = var.tmc-worker_replicas
          overrides    = jsonencode(local.tkgs_nodepool_a_overrides)

          os_image {
            name    = "photon"
            version = "3"
            arch    = "amd64"
          }
        }
      }

      network {
        pod_cidr_blocks = [
          "100.96.0.0/11",
        ]
        service_cidr_blocks = [
          "100.64.0.0/13",
        ]
        service_domain = "cluster.local"
      }
    }
  }

  timeout_policy {
    timeout             = 60
    wait_for_kubeconfig = true
    fail_on_timeout     = true
  }
}