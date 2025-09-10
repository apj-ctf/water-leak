variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "The GCP region"
  type        = string
}

provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_storage_bucket" "public_bucket" {
  name          = "ctf-files"
  location      = var.region
  force_destroy = true

  uniform_bucket_level_access = true

  labels = {
    environment = "public"
  }
}

resource "google_storage_bucket_object" "uploaded_file" {
  name         = "leaky-bucket-black-background.png"
  bucket       = google_storage_bucket.public_bucket.name
  source       = "leaky-bucket-black-background.png"
  content_type = "image/png"
}

resource "google_storage_bucket_iam_member" "public_access" {
  bucket = google_storage_bucket.public_bucket.name
  role   = "roles/storage.objectViewer"
  member = "allUsers"
}

output "image_url" {
  description = "Public URL of the file"
  value       = "https://storage.googleapis.com/${google_storage_bucket.public_bucket.name}/${google_storage_bucket_object.uploaded_file.name}"
}
