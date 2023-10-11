# VPC
resource "google_compute_network" "vpc" {
  name                    = "${var.gke_project_id}-gitops-bridge-vpc"
  auto_create_subnetworks = "false"
}

# Subnet
resource "google_compute_subnetwork" "subnet" {
  name          = "${var.gke_project_id}-gitops-bridge-gke-subnet"
  region        = var.gke_region
  network       = google_compute_network.vpc.name
  ip_cidr_range = "10.10.0.0/24"
}