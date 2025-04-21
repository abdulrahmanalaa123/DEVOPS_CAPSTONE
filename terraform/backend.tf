terraform {
  backend "s3" {
    bucket = "capstone-3az-backend"
    key    = "initial/backend"
    region = "us-east-1"
  }
}
