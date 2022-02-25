variable "project" {
  default = "change_me"
}
variable "region" {
  default = "us-central1"
}
provider "google" {
  project = var.project
  region  = var.region
}
resource "google_compute_network" "vpc" {
  name                    = "${var.project}-vpc"
  auto_create_subnetworks = "false"
}

# Subnet
resource "google_compute_subnetwork" "subnet" {
  name          = "${var.project}-subnet"
  region        = var.region
  network       = google_compute_network.vpc.name
  ip_cidr_range = "10.10.0.0/24"
}

# SA
resource "google_service_account" "default" {
  account_id   = "terraform"
  display_name = "Service Account"
}

#GKE
resource "google_container_cluster" "primary" {
  name                  = "my-gke-cluster"
  location              = "us-central1"
  enable_shielded_nodes = true
  network               = google_compute_network.vpc.name
  subnetwork            = google_compute_subnetwork.subnet.name
  master_authorized_networks_config {
    cidr_blocks {
      cidr_block = "69.230.65.40/32"
    }
  }
  cluster_autoscaling {
    enabled = true
    resource_limits {
      resource_type = "memory"
      minimum       = 8
      maximum       = 68
    }
    resource_limits {
      resource_type = "cpu"
      minimum       = 2
      maximum       = 64
    }
  }
  remove_default_node_pool = true
  initial_node_count       = 1
}
# GKE pool
resource "google_container_node_pool" "non_default_pool" {
  name     = "${google_container_cluster.primary.name}-node-pool"
  location = var.region
  cluster  = google_container_cluster.primary.name
  initial_node_count = 1
  autoscaling {
    min_node_count = 2
    max_node_count = 4
  }

  node_config {
    disk_size_gb = 30
    preemptible  = true
    machine_type = "e2-standard-2"
    service_account = google_service_account.default.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring"
    ]
  }
}
