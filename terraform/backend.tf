terraform {
  backend "s3" {
    bucket = "relops-terraform-states"
    key    = "tf_state/timeline_repo/terraform.tfstate"
    dynamodb_table = "timeline_repo_terraform_state_lock"
    region = "us-east-1"
  }
}
