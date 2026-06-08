terraform {
  backend "s3" {
    bucket         = "sumayah-eks-platform-tf-state-739340816202"
    key            = "eks/dev/terraform.tfstate"
    region         = "eu-west-2"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}