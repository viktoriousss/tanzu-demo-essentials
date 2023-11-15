# Create Tanzu Mission Control Tanzu Kubernetes Grid Service workload cluster entry
resource "tanzu-mission-control_cluster" "create_tkgs_workload" {
  management_cluster_name = var.tmc-management_cluster_name
  provisioner_name        = var.tmc-provisioner_name
  name                    = var.tmc-tkg_cluster_name

  meta {
    labels = { "owner" : var.tmc-owner }
  }

  spec {
    cluster_group = var.tmc-cluster_group
    tkg_service_vsphere {
      settings {
        network {
          pods {
            cidr_blocks = [
              "172.20.0.0/16", # pods cidr block by default has the value `172.20.0.0/16`
            ]
          }
          services {
            cidr_blocks = [
              "10.96.0.0/16", # services cidr block by default has the value `10.96.0.0/16`
            ]
          }
        }
        storage {
          classes = [
            "vc01cl01-t0compute",
          ]
          default_class = "vc01cl01-t0compute"
        }
      }

      distribution {
        version = "v1.23.8---vmware.3-tkg.1"
      }

      topology {
        control_plane {
          class         = "best-effort-medium"
          storage_class = "vc01cl01-t0compute"
          # storage class is either `wcpglobal-storage-profile` or `gc-storage-profile`
          high_availability = false
          volumes {
            capacity          = 4
            mount_path        = "/var/lib/etcd"
            name              = "etcd-0"
            pvc_storage_class = "vc01cl01-t0compute"
          }
        }
        node_pools {
          spec {
            worker_node_count = "3"
            cloud_label = {
              "key1" : "val1"
            }
            node_label = {
              "key2" : "val2"
            }

            tkg_service_vsphere {
              class          = "best-effort-medium"
              storage_class  = "vc01cl01-t0compute"
              #failure_domain = "domain-c8"
              # storage class is either `wcpglobal-storage-profile` or `gc-storage-profile`
              volumes {
                capacity          = 4
                mount_path        = "/var/lib/etcd"
                name              = "etcd-0"
                pvc_storage_class = "vc01cl01-t0compute"
              }
            }
          }
          info {
            name        = "default-nodepool" # default node pool name `default-nodepool`
            description = "tkgs workload nodepool"
          }
        }
      }
    }
  }
  depends_on = [ tanzu-mission-control_cluster_group.viktorious-tf ]
}