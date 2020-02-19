terraform {
  required_version = "~> 0.12"
  required_providers {
    aws = "~> 2.0"
  }

  backend "s3" {
    bucket = "relops-tf-states"
    key    = "timeline_repo.tfstate"
    region = "us-west-2"
  }
}
