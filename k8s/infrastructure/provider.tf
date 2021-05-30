provider "google" {
  project = var.project
  version = "3.40.0"
  region  = var.cluster_location
}

provider "google-beta" {
  version = "3.40.0"
  project = var.project
  region  = var.cluster_location
}