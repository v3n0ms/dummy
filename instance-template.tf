data "google_compute_image" "coreos" {
  family  = "cos-stable"
  project = "cos-cloud"
}

module "gce-container" {
  source  = "terraform-google-modules/container-vm/google"
  version = "~> 2.0"

  container = {
    image   = "asia.gcr.io/dummy-project-365407/pos"
    command = ""
    env = [
      {
        name  = "DB_HOST",
        value = "34.150.222.6"
      },
      {
        name  = "DB_NAME",
        value = "pos"
      },
      {
        name  = "DB_USER",
        value = "root"
      },
      {
        name  = "DB_PASSWORD",
        value = "Sup3r$ecretP@ss"
      }
    ]

  }

  restart_policy = "Always"
}

resource "google_compute_instance_template" "template" {
  name         = "pos-instance-template"
  machine_type = "f1-micro"
  project      = "dummy-project-365407"
  region       = "us-west2"

  disk {
    source_image = data.google_compute_image.coreos.id
  }

  network_interface {
    network = google_compute_network.default.name

    # secret default
    access_config {}

  }

  metadata = {
    gce-container-declaration = module.gce-container.metadata_value
  }

  labels = {
    container-vm = module.gce-container.vm_container_label
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