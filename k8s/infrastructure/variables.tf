variable "cluster_location" {
  default = "us-central1"
}

variable "project_id" {
  default = "playground-s-11-77048119"
}

variable "project_code" {
  default = "minimal"
}

variable "ip_range" {
  default = "10.76.12.0/22"
}

variable "node_machine_type_p1" {
  default = "e2-micro"
}

variable "node_machine_type_p2" {
  default = "e2-micro"
}

variable "cluster_name_cl2" {
  default = "testing-1"
}

variable "min_master_version_cl2" {
  default = "1.19.9-gke.1400"
}

variable "min_node_count_cl2" {
  default = "1"
}

variable "max_node_count_cl2" {
  default = "2"
}

variable "project" {
  default = "playground-s-11-77048119"
}

variable "name_jumphost" {
  default = "bastion-central1"
}

variable "image" {
  type    = string
  default = "debian-cloud/debian-9"
}

variable "tag" {
  type    = string
  default = "bastion-ssh-access"
}

# Bucket donde se guardan todos los secretos.
variable "bucket_key" {
  default = ""
}

variable "directory" {
  default = "privatekey"
}

variable "zone" {
  type    = string
  default = "us-central1-a"
}

variable "total_public_ips" {
  type    = string
  default = "10"
}

variable "uses_public_ips" {
  type    = string
  default = "10"
}

variable "network_vpc" {
  default = "testing"
}

variable "storage_class" {
  type        = string
  default     = "MULTI_REGIONAL"
  description = "The Storage Class of the new bucket. Supported values include: MULTI_REGIONAL, REGIONAL, NEARLINE, COLDLINE."
}

variable "bucket_name" {
  type        = string
  default     = ""
  description = "Name of the bucket, must be unique global name"
}

variable "network" {
  type        = string
  description = "The full name of the Google Compute Engine network to which the instance is connected."
  default     = "default"
}

variable "enable_network_egress_export_cls2" {
  default = true
}

variable "enable_resource_consumption_export_cls2" {
  default = true
}

variable "resource_usage_export_dataset_id_cls2" {
  default = ""
}