provider "aws" {
  access_key = var.aws-access-key
  secret_key = var.aws-secret-key
  region     = var.aws-region
}

resource "aws_key_pair" "quest-demo-key" {
  key_name   = "quest-key"
  public_key = var.ssh-public-key
}
