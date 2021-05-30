variable "cluster_name" {
  description = "Nombre del cluster de k8s"
  default     = "cluster-test"
}

variable "cluster_location" {
  description = "Nombre de la zona o región del cluster de k8s"
  default     = "us-east4"
}

variable "node_count" {
  description = "Cantidad de nodos en el cluster de k8s"
  default     = 2
}

variable "node_machine_type_p1" {
  description = "Nombre del tipo de maquina del cluster de k8s"
  default     = "e2-medium"
}

variable "node_machine_type_p2" {
  description = "Nombre del tipo de maquina del cluster de k8s"
  default     = "e2-medium"
}

variable "node_pool_oauth_scopes" {
  description = "Oauth del node pool"
  type        = list(string)

  default = [
    "https://www.googleapis.com/auth/compute",
    "https://www.googleapis.com/auth/devstorage.read_only",
    "https://www.googleapis.com/auth/logging.write",
    "https://www.googleapis.com/auth/monitoring",
    "https://www.googleapis.com/auth/service.management",
    "https://www.googleapis.com/auth/servicecontrol",
    "https://www.googleapis.com/auth/cloud-platform",
    "https://www.googleapis.com/auth/cloud_debugger",
    "https://www.googleapis.com/auth/trace.append",
    "https://www.googleapis.com/auth/monitoring.write",
  ]
}

variable "ip_allocation_policy" {
  description = "Dirección de IP del node pool"
  type        = list(any)
  default     = [{ "use_ip_aliases" = true }]
}

variable "image_type" {
  description = "Tipo de imagen de node pool"
  type        = string
  default     = "COS"
}

variable "auto_upgrade" {
  description = "Activar auto upgrade de un node pool"
  default     = "true"
}

variable "network" {
  description = "VPC donde se deploya el cluster k8s"
  default     = "default"
}

variable "subnetwork" {
  description = "subnet donde se deploya el cluster k8s"
  default     = "default"
}

variable "preemtible_node" {
  description = "Activar nodos preemtible de un node pool"
  default     = "false"
}

variable "network_tags" {
  description = "Tags que van a ser agregado a los nodos del pool"
  type        = list(string)
  default     = []
}

variable "min_master_version" {
  description = "Mínima versión del master para el cluster de K8S"
  default     = ""
}

variable "master_ipv4_cidr_block" {
  description = "Segmento de red en notación CIDR que se usará para el cluster privado. Ver RFC 1918."
  default     = "172.16.0.0/28"
}

variable "enable_private_nodes" {
  description = "Determina si los nodos del cluster se crearán como nodos privados."
  default     = "true"
}

variable "enable_private_endpoint" {
  description = "Determina si la dirección IP interna del master será usada (true) o no (false) como endpoint del cluster."
  default     = "true"
}

variable "sa_cluster_name" {
  description = "Nombre de la cuenta de servicio para utilizar en el cluster"
  default     = "sa-cluster"
}

variable "ip_range" {
  description = "IP autorizada para acceder al master"
  default     = "10.0.0.0/8"
}

variable "min_node_count" {
  description = "Cantidad minima de nodos para el autoscaling"
  default     = 2
}

variable "enable_p1" {
  description = "Habilita el pool 1"
  default     = true
}

variable "enable_p2" {
  description = "Habilita el pool 2"
  default     = false
}
variable "max_node_count" {
  description = "Cantidad maxima de nodos para el autoscaling"
  default     = 3
}

variable "auth_istio" {
  default = "AUTH_MUTUAL_TLS"
}

variable "disk" {
  description = "Tamaño del disco"
  default     = "50"
}

variable "disabled_istio" {
  default = "false"
}

variable "autoscaling" {
  description = "Habiliar o deshabilitar el autoscalamiento de los nodos"
  default     = true
}

# Maintenece windows
#variable start_time {
#  description = "Hora donde empieza a ejecutar el mantenimiento (UTC)."
#  default     = "02:00"
#}

variable "vpa_enabled" {
  description = "Habiliar o deshabilitar el VPA en el cluster"
  default     = true
}

variable "resource_usage_export_dataset_id" {
  type        = string
  description = "The ID of a BigQuery Dataset for using BigQuery as the destination of resource usage export."
  default     = ""
}

variable "enable_network_egress_export" {
  type        = bool
  description = "Whether to enable network egress metering for this cluster. If enabled, a daemonset will be created in the cluster to meter network egress traffic."
  default     = false
}

variable "enable_resource_consumption_export" {
  type        = bool
  description = "Whether to enable resource consumption metering on this cluster."
  default     = false
}

variable "project_id" {
    type = string
    description = "The Project ID"
    default = "playground-s-11-77048119"
}