resource "google_compute_instance" "default" {
  name         = "retail-pos-helloworld"
  machine_type = "f1-micro"
  zone         = "us-east4-b"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }
  network_interface {
    network = google_compute_network.default.name

    access_config {

    }
  }

  metadata_startup_script = "sudo apt-get update && sudo apt-get install apache2 -y &&  echo 'hello world' | sudo tee /var/www/html/index.html"
  tags                    = ["http-server"]
}

resource "google_compute_firewall" "http-server" {

  name    = "default-allow-http-terraform"
  network = google_compute_network.default.name

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["http-server"]
}


output "ip" {

  value = google_compute_instance.default.network_interface.0.access_config.0.nat_ip

}
