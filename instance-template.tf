resource "google_compute_instance_template" "template" {
  name         = "pos-instance-template"
  machine_type = "f1-micro"
  project     = "dummy-project-365407"
  region      = "us-east2"

  disk {
    source_image = "debian-cloud/debian-11"
  }

  network_interface {
    network = google_compute_network.default.name

    # secret default
    access_config {

    }
  }

  # secret default
  service_account {
    scopes = [
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring.write",
      "https://www.googleapis.com/auth/pubsub",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/trace.append",
    ]
  }
}