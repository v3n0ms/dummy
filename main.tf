provider "google" {
  credentials = file("database_creds.json")
  alias       = "db"
  project     = "dummy-project-365407"
  region      = "us-east4"
}

resource "google_compute_global_address" "private_ip_address" {
    provider= google-beta
    name          = "${google_compute_network.default.name}"
    purpose       = "VPC_PEERING"
    address_type = "INTERNAL"
    prefix_length = 16
    network       = "${google_compute_network.default.name}"
}

resource "google_service_networking_connection" "private_vpc_connection" {
    provider= google-beta
    network       = "${google_compute_network.default.self_link}"
    service       = "servicenetworking.googleapis.com"
    reserved_peering_ranges = ["${google_compute_global_address.private_ip_address.name}"]
}

resource "google_sql_database_instance" "mysql" {
  provider            = google.db
  name                = "mysql-instance"
  database_version    = "MYSQL_8_0"
  region              = "us-east4"
  deletion_protection = false
  depends_on = [google_service_networking_connection.private_vpc_connection]

  settings {
    tier = "db-f1-micro"
    ip_configuration {
      ipv4_enabled = false
      private_network = "projects/dummy-project-365407/global/networks/${google_compute_network.default.name}"
    }
  }
}
resource "google_sql_database" "database" {
  provider  = google.db
  name      = "pos"
  instance  = google_sql_database_instance.mysql.name
  charset   = "utf8"
  collation = "utf8_general_ci"

}
resource "google_sql_user" "users" {
  provider = google.db
  name     = local.envs["USER"]
  instance = google_sql_database_instance.mysql.name
  host     = "%"
  password = local.envs["PASSWORD"]
}

output "instance_ip_addr" {
  value       = google_sql_database_instance.mysql.private_ip_address
  description = "The private IP address of the main server instance."
}