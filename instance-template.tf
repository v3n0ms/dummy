
resource "google_compute_firewall" "http-server" {

  name    = "default-allow-http-terraform"
  network = google_compute_network.default.name

  allow {
    protocol = "tcp"
    ports    = ["22", "8080"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["http-server"]

}

resource "google_compute_firewall" "internet-access" {

  name    = "default-allow-internet"
  network = google_compute_network.default.name

  allow {
    protocol = "all"
  }
  direction = "EGRESS"
  destination_ranges = ["0.0.0.0/0"]
  target_tags   = ["allow-internet"]

}

resource "google_compute_instance_template" "template" {
  name         = "pos-instance-template"
  machine_type = "f1-micro"
  project      = "dummy-project-365407"
  region       = "us-west2"

  disk {
    source_image = "ubuntu-os-cloud/ubuntu-2004-lts"
  }

  network_interface {
    network = google_compute_network.default.name

    # secret default
    access_config {}


  }


  metadata_startup_script = <<-EOF
#!/bin/bash

sudo apt update
sudo apt install --yes apt-transport-https ca-certificates curl gnupg2 software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y

sudo echo "deb https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list 
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo tee /usr/share/keyrings/cloud.google.gpg
sudo apt-get update && sudo apt-get install google-cloud-cli  -y

sudo systemctl start docker
METADATA=http://metadata.google.internal/computeMetadata/v1
SVC_ACCT=$METADATA/instance/service-accounts/default
ACCESS_TOKEN=$(curl -H 'Metadata-Flavor: Google' $SVC_ACCT/token \
    | cut -d'"' -f 4)
sudo docker login  -u _token -p $ACCESS_TOKEN https://asia.gcr.io

sudo docker run -p 8080:8080 -d  - e SPRING_DATASOURCE_URL=jdbc:mysql://:3306/pos \
      -e  SPRING_DATASOURCE_USERNAME=root \
      -e  SPRING_DATASOURCE_PASSWORD=Sup3r$ecretP@ss \
      -e  SPRING_JPA_HIBERNATE_DDL_AUTO=update asia.gcr.io/dummy-project-365407/pos
EOF


  tags                    = ["http-server", "allow-internet"]

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