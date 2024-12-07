provider "aws" {
  region = var.aws_desired_region
}

terraform {
  backend "s3" {
    bucket = "terraform-state-${terraform.workspace}"
    key = "${terraform.workspace}/terraform.tfstate"  
    region = var.backend_bucket_region
    dynamodb_table = "terrafrom-locks-${terraform.workspace}"
    encrypt = true
  }
}