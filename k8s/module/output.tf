output "cluster_name" {
  description = "Id del cluster k8s creado"
  value       = google_container_cluster.primary.name
}

output "endpoint" {
  description = "endpoint del cluster de k8s"
  value       = google_container_cluster.primary.endpoint
}
