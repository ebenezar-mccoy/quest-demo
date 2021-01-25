variable "vpc-security-group-ids" {
  type    = list(string)
  default = []
}

variable "subnets" { type = any }

variable "vpc-id" {
  type = string
}

variable "name" {
  type = string
}

variable "node-server-public-ip" {
  type = string 
}
