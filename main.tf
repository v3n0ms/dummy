provider "google" {
  credentials = file("database_creds.json")
  alias       = "db"
  project     = "dummy-project-365407"
  region      = "us-east4"
}

resource "google_sql_database_instance" "mysql" {
  provider            = google.db
  name                = "mysql-instance"
  database_version    = "MYSQL_8_0"
  region              = "us-east4"
  deletion_protection = false

  settings {
    tier = "db-f1-micro"
    ip_configuration {
      ipv4_enabled = true
      authorized_networks {
        value = "0.0.0.0/0"
      }
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
  name     = "root"
  instance = google_sql_database_instance.mysql.name
  host     = "%"
  password = "Sup3r$ecretP@ss"
}