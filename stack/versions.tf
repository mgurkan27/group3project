terraform {
  required_version = ">= 0.13"
}


terraform {
  required_providers {
    aws = {
      region     = var.aws_region
      profile    = var.aws_profile
      version = ">= 2.7.0"
      source  = "hashicorp/aws"
    }
  }
}