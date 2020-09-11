terraform {
  backend "s3" {
    bucket = "mustafagurkan27"
    key    = "myec2/ec2-from-terraform.tfstate"
    region = "us-west-1"
  }
}