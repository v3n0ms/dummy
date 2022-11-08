
resource "google_sql_database_instance" "mysql" {
  name             = "mysql-instance"
  database_version = "MYSQL_8_0"
  region           = "us-east4"
  

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
  name      = "pos"
  instance  = google_sql_database_instance.mysql.name
  charset   = "utf8"
  collation = "utf8_general_ci"
}
resource "google_sql_user" "users" {
  name     = "root"
  instance = google_sql_database_instance.mysql.name
  host     = "%"
  password = "Sup3r$ecretP@ss"
}