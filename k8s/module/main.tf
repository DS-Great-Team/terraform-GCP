resource "google_container_cluster" "primary" {
  provider                 = google-beta
  name                     = var.cluster_name
  location                 = var.cluster_location
  min_master_version       = var.min_master_version
  remove_default_node_pool = true
  initial_node_count       = 1
  network                  = var.network
  subnetwork               = var.subnetwork
  project                  = var.project_id
  dynamic "ip_allocation_policy" {
    for_each = var.ip_allocation_policy
    content {
      cluster_ipv4_cidr_block      = lookup(ip_allocation_policy.value, "cluster_ipv4_cidr_block", null)
      cluster_secondary_range_name = lookup(ip_allocation_policy.value, "cluster_secondary_range_name", null)
      services_ipv4_cidr_block      = lookup(ip_allocation_policy.value, "services_ipv4_cidr_block", null)
      services_secondary_range_name = lookup(ip_allocation_policy.value, "services_secondary_range_name", null)
    }
  }

  private_cluster_config {
    enable_private_endpoint = var.enable_private_endpoint
    enable_private_nodes    = var.enable_private_nodes
    master_ipv4_cidr_block  = var.master_ipv4_cidr_block
  }

  addons_config {
    istio_config {
      disabled = var.disabled_istio
      auth     = var.auth_istio
    }
  }

  master_authorized_networks_config {
    cidr_blocks {
      cidr_block   = var.ip_range
      display_name = "ip_range"
    }
  }

  #maintenance_policy {
  #  daily_maintenance_window {
  #    start_time = var.start_time
  #  }
  #}

  vertical_pod_autoscaling {
    enabled = var.vpa_enabled
  }
  
  dynamic "resource_usage_export_config" {
    for_each = var.resource_usage_export_dataset_id != "" ? [{
      enable_network_egress_metering       = var.enable_network_egress_export
      enable_resource_consumption_metering = var.enable_resource_consumption_export
      dataset_id                           = var.resource_usage_export_dataset_id
    }] : []

    content {
      enable_network_egress_metering       = resource_usage_export_config.value.enable_network_egress_metering
      enable_resource_consumption_metering = resource_usage_export_config.value.enable_resource_consumption_metering
      bigquery_destination {
        dataset_id = resource_usage_export_config.value.dataset_id
      }
    }
  }

}

locals {
  autoscaling_config = {
    min_count = var.min_node_count
    max_count = var.max_node_count
  }
}

resource "google_container_node_pool" "primary_pool" {
  name     = "p1-${var.cluster_name}"
  count    = var.enable_p1 ? 1 : 0
  location = var.cluster_location
  cluster  = google_container_cluster.primary.name
  project  = var.project_id

  initial_node_count = var.autoscaling ? lookup(local.autoscaling_config, "min_count") : null

  dynamic "autoscaling" {
    for_each = var.autoscaling ? [local.autoscaling_config] : []
    content {
      min_node_count = lookup(autoscaling.value, "min_count")
      max_node_count = lookup(autoscaling.value, "max_count")
    }
  }

  management {
    auto_upgrade = var.auto_upgrade
  }

  node_config {
    disk_size_gb    = var.disk
    preemptible     = var.preemtible_node
    machine_type    = var.node_machine_type_p1
    oauth_scopes    = var.node_pool_oauth_scopes
    tags            = var.network_tags
    service_account = google_service_account.service_account_cluster_gke.email
  }

  lifecycle {
    ignore_changes = [initial_node_count]
  }
}

resource "google_container_node_pool" "secondary_pool" {
  name     = "p2-${var.cluster_name}"
  count    = var.enable_p2 ? 1 : 0
  location = var.cluster_location
  cluster  = google_container_cluster.primary.name

  initial_node_count = var.autoscaling ? lookup(local.autoscaling_config, "min_count") : null

  dynamic "autoscaling" {
    for_each = var.autoscaling ? [local.autoscaling_config] : []
    content {
      min_node_count = lookup(autoscaling.value, "min_count")
      max_node_count = lookup(autoscaling.value, "max_count")
    }
  }

  management {
    auto_upgrade = var.auto_upgrade
  }

  node_config {
    disk_size_gb    = var.disk
    preemptible     = var.preemtible_node
    machine_type    = var.node_machine_type_p2
    oauth_scopes    = var.node_pool_oauth_scopes
    tags            = var.network_tags
    service_account = google_service_account.service_account_cluster_gke.email
  }

  lifecycle {
    ignore_changes = [initial_node_count]
  }
}

locals {
  display_name = "${var.sa_cluster_name}-${var.cluster_name}"

  account_id = substr(local.display_name, 0, min(length(local.display_name), 29))
}

resource "google_service_account" "service_account_cluster_gke" {
  account_id   = local.account_id
  display_name = local.display_name
  project      = var.project_id
}

resource "google_project_iam_member" "service_account_role_logging_logwriter" {
  role = "roles/logging.logWriter"
  project                  = var.project_id
  member = format(
    "serviceAccount:%s",
    google_service_account.service_account_cluster_gke.email,
  )
}

resource "google_project_iam_member" "service_account_role_monitoring_metricWriter" {
  role = "roles/monitoring.metricWriter"
  member = format(
    "serviceAccount:%s",
    google_service_account.service_account_cluster_gke.email,
  )
  project                  = var.project_id
}

resource "google_project_iam_member" "service_account_role_monitoring_viewer" {
  role = "roles/monitoring.viewer"
  member = format(
    "serviceAccount:%s",
    google_service_account.service_account_cluster_gke.email,
  )
  project                  = var.project_id
}

resource "google_project_iam_member" "service_account_role_storage_objectViewer" {
  role = "roles/storage.objectViewer"
  member = format(
    "serviceAccount:%s",
    google_service_account.service_account_cluster_gke.email,
  )
  project                  = var.project_id
}

resource "google_project_iam_member" "service_account_role_servicemanagement_admin" {
  role = "roles/servicemanagement.admin"
  member = format(
    "serviceAccount:%s",
    google_service_account.service_account_cluster_gke.email,
  )
  project                  = var.project_id
}

resource "google_project_iam_member" "service_account_role_clouddebugger_admin" {
  role = "roles/clouddebugger.user"
  member = format(
    "serviceAccount:%s",
    google_service_account.service_account_cluster_gke.email,
  )
  project                  = var.project_id
}

resource "google_project_iam_member" "service_account_role_errorreporting_admin" {
  role = "roles/errorreporting.admin"
  member = format(
    "serviceAccount:%s",
    google_service_account.service_account_cluster_gke.email,
  )
  project                  = var.project_id
}

resource "google_project_iam_member" "service_account_role_cloudtrace_admin" {
  role = "roles/cloudtrace.admin"
  member = format(
    "serviceAccount:%s",
    google_service_account.service_account_cluster_gke.email,
  )
  project                  = var.project_id
}

resource "google_project_iam_member" "service_account_role_logging_admin" {
  role = "roles/logging.admin"
  member = format(
    "serviceAccount:%s",
    google_service_account.service_account_cluster_gke.email,
  )
  project                  = var.project_id
}

resource "google_project_iam_member" "service_account_role_monitoring_admin" {
  role = "roles/monitoring.admin"
  member = format(
    "serviceAccount:%s",
    google_service_account.service_account_cluster_gke.email,
  )
  project                  = var.project_id
}

resource "google_project_iam_member" "service_account_role_cloudkms_decrypter" {
  role = "roles/cloudkms.cryptoKeyDecrypter"
  member = format(
    "serviceAccount:%s",
    google_service_account.service_account_cluster_gke.email,
  )
  project                  = var.project_id
}

resource "google_project_iam_member" "service_account_role_cloudprofiler_agent" {
  role = "roles/cloudprofiler.agent"
  member = format(
    "serviceAccount:%s",
    google_service_account.service_account_cluster_gke.email,
  )
  project                  = var.project_id
}