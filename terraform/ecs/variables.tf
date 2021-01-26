variable "vpc-security-group-ids" {
  type    = list(string)
  default = []
}

variable "desired_count" {
  type = number
}

variable "ecs-subnets" {
  type    = list(string)
  default = []
}

variable "lb-subnets" {
  type    = list(string)
  default = []
}

variable "vpc-id" {
  type = string
}

variable "name" {
  type = string
}

variable "node-server-public-ip" {
  type = string
}
