provider "aws" {
  region     = var.aws-region
}

resource "aws_key_pair" "quest-demo-key" {
  key_name   = "quest-key"
  public_key = var.ssh-public-key
}

terraform {
  backend "s3" {
    bucket     = "quest-demo-tf"
    key        = "terraform.tfstate"
  }
}
