data "google_compute_image" "coreos" {
  family  = "cos-stable"
  project = "cos-cloud"
}


resource "google_compute_firewall" "http-server" {

  name    = "default-allow-http-terraform"
  network = google_compute_network.default.name

  allow {
    protocol = "tcp"
    ports    = ["80", "22", "8080"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["http-server"]

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

  metadata_startup_script = <<-EOF
#!/bin/bash

toolbox \
sudo apt-get install apt-transport-https ca-certificates gnupg \
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list \
echo "deb https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list \
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add - \
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add - \
sudo apt-get update && sudo apt-get install google-cloud-cli \

gcloud auth activate-service-account --key-file=credentials.json \

docker pull asia.gcr.io/dummy-project-365407/pos tag pos \
docker run -p 8080:8080 -d -e DB_USER=root -e DB_NAME=pos -e DB_PASSWORD=Sup3r$ecretP@ss -e DB_HOST=34.150.222.6 pos 
EOF
  tags                    = ["http-server"]

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