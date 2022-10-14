provider "google" {
  credentials = file("credentials.json")
  project     = "dummy-project-365407"
  region      = "us-east4"
}

terraform {
  backend "gcs" {
    bucket      = "demo-bucket-dummy-00"
    path        = "dev/terraform.tfstate"
    project     = "dummy-project-365407"
    credentials = file("gcs.json")
  }
}
