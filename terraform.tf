provider "google" {
  credentials = file("credentials.json")
  project     = "dummy-project-365407"
  region      = "asia-south1"
}