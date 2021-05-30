module "gke_cl2" {
  source                             = "/home/danijarvis/terraform-GCP/k8s/module"
  cluster_name                       = var.cluster_name_cl2
  enable_p1                          = true
  enable_p2                          = false
  cluster_location                   = var.cluster_location
  min_master_version                 = var.min_master_version_cl2
  ip_range                           = var.ip_range
  node_machine_type_p1               = var.node_machine_type_p1
  node_machine_type_p2               = var.node_machine_type_p2
  min_node_count                     = var.min_node_count_cl2
  max_node_count                     = var.max_node_count_cl2
  network                            = google_compute_network.vpc_network.name
  subnetwork                         = google_compute_subnetwork.subnetwork.name
  autoscaling                        = true
  vpa_enabled                        = true
  disabled_istio                     = true
  master_ipv4_cidr_block             = "172.17.0.0/28"
  enable_network_egress_export       = var.enable_network_egress_export_cls2
  enable_resource_consumption_export = var.enable_resource_consumption_export_cls2
  resource_usage_export_dataset_id   = var.resource_usage_export_dataset_id_cls2
}

resource "google_compute_subnetwork" "subnetwork" {
  name          = "subnet-central"
  ip_cidr_range = var.ip_range
  region        = var.cluster_location
  network       = google_compute_network.vpc_network.self_link
}

resource "google_compute_network" "vpc_network" {
  name                    = var.network_vpc
  auto_create_subnetworks = false
  project                 = var.project
}