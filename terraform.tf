provider "google" {
    credentials = "${file("credentials.json")}"
    project = "retail-pos-bfe9"
    region = "asia-south1"
}