provider "google" {
  credentials = file("credentials.json")
  project     = "daring-cache-365406"
  region      = "asia-south1"
}