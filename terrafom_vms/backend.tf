terraform {
  backend "s3" {
    bucket = "terraform-backend-hkt"
    key    = "terraform/backend"
    region = "ap-south-1"
  }
}
