terraform {
  backend "s3" {
    bucket = "mustafagurkan"
    key    = "myec2/ec2-from-terraform.tfstate"
    region = "us-west-1"
  }
}