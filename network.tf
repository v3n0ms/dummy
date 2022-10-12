resource "google_compute_network" "default" {
name = "default"
}
resource "google_compute_subnetwork" "public-subnetwork" {
name = "terraform-subnetwork"
ip_cidr_range = "10.2.0.0/16"
region = "asia-south1"
network = google_compute_network.default.name
}