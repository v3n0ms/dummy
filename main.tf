
resource "google_sql_database_instance" "master" {
name = "instance_name"
database_version = "MYSQL_8"
region = "us-east4"
settings {
tier = "db-f1-micro"
}
}
resource "google_sql_database" "database" {
name = "pos"
instance = "${google_sql_database_instance.master.name}"
charset = "utf8"
collation = "utf8_general_ci"
}
resource "google_sql_user" "users" {
name = "root"
instance = "${google_sql_database_instance.master.name}"
host = "%"
password = "Sup3r$ecretP@ss"
}