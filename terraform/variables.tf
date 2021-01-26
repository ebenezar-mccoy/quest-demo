variable "aws-access-key" { type = string }
variable "aws-secret-key" { type = string }
variable "ssh-public-key" { type = string }

variable "aws-region" {
  type    = string
  default = "us-east-1"
}

variable "aws_subnet-availability_zone_id_0" {
  type    = string
  default = "use1-az2"
}

variable "aws_subnet-availability_zone_id_1" {
  type    = string
  default = "use1-az4"
}
