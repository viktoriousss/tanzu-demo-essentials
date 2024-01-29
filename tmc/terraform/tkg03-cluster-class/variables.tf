# TMC Connection properties
variable "tmc-endpoint" {
    type = string    
    default = ""
}

variable "tmc-vmw_cloud_api_token" {
    type = string    
    default = ""
}

# Generic TKG settings
variable "tmc-management_cluster_name" {
    type = string    
    default = ""
}

variable "tmc-provisioner_name" {
    type = string    
    default = ""
}

variable "tmc-cluster_group_name" {
    type = string    
    default = ""
}

variable "tmc-tkg_cluster_name" {
    type = string    
    default = ""
}

variable "tmc-owner" {
    type = string    
    default = ""
}

variable "tmc-control_plane_replicas" {
    type = number
    default = 1
}

variable "tmc-worker_replicas" {
    type = number
    default = 1
}

variable "tmc-control_plane_size" {
    type = string    
    default = ""
}

variable "tmc-worker_plane_size" {
    type = string    
    default = ""
}

variable "tmc-kubernetes_version" {
    type = string    
    default = ""
}