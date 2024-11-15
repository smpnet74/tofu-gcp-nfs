variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "The GCP region"
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "The GCP zone"
  type        = string
  default     = "us-central1-a"
}

variable "nfs_disk_size" {
  description = "Size of the NFS disk in GB"
  type        = number
  default     = 30
}

variable "nfs_instance_type" {
  description = "Machine type for NFS server"
  type        = string
  default     = "e2-micro"
}
