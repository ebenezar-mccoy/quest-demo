resource "aws_internet_gateway" "quest-demo" {
  vpc_id = aws_vpc.quest-demo.id
}

resource "aws_route_table" "allow-outgoing-access" {
  vpc_id = aws_vpc.quest-demo.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.quest-demo.id
  }

  tags = {
    Name = "Route Table Allowing Outgoing Access"
  }
}

resource "aws_route_table_association" "quest-demo-subnet-node-server" {
  subnet_id      = aws_subnet.quest-demo-subnet-node-server.id
  route_table_id = aws_route_table.allow-outgoing-access.id
}

resource "aws_route_table_association" "quest-demo-subnet-ecs-1" {
  subnet_id      = aws_subnet.quest-demo-subnet-ecs-1.id
  route_table_id = aws_route_table.allow-outgoing-access.id
}

resource "aws_route_table_association" "quest-demo-subnet-ecs-2" {
  subnet_id      = aws_subnet.quest-demo-subnet-ecs-2.id
  route_table_id = aws_route_table.allow-outgoing-access.id
}

resource "aws_route_table_association" "quest-demo-subnet-lb-1" {
  subnet_id      = aws_subnet.quest-demo-subnet-lb-1.id
  route_table_id = aws_route_table.allow-outgoing-access.id
}

resource "aws_route_table_association" "quest-demo-subnet-lb-2" {
  subnet_id      = aws_subnet.quest-demo-subnet-lb-2.id
  route_table_id = aws_route_table.allow-outgoing-access.id
}

resource "aws_security_group" "allow-internal-http" {
  name        = "allow-internal-http"
  description = "Allow internal HTTP requests"
  vpc_id      = aws_vpc.quest-demo.id

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.quest-demo.cidr_block]
  }
}

resource "aws_security_group" "allow-http" {
  name        = "allow-http"
  description = "Allow HTTP inbound traffic"
  vpc_id      = aws_vpc.quest-demo.id

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "allow-ssh" {
  name        = "allow-ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.quest-demo.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "allow-all-outbound" {
  name        = "allow-all-outbound"
  description = "Allow all outbound traffic"
  vpc_id      = aws_vpc.quest-demo.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_subnet" "quest-demo-subnet-node-server" {
  availability_zone_id = var.aws_subnet-availability_zone_id_0
  cidr_block           = "10.0.0.0/24"
  vpc_id               = aws_vpc.quest-demo.id

  tags = {
    Name = "quest Demo Subnet (node-server)"
  }
}

resource "aws_subnet" "quest-demo-subnet-ecs-1" {
  availability_zone_id = var.aws_subnet-availability_zone_id_0
  cidr_block           = "10.0.1.0/24"
  vpc_id               = aws_vpc.quest-demo.id

  tags = {
    Name = "quest Demo Subnet (ECS 1)"
  }
}

resource "aws_subnet" "quest-demo-subnet-ecs-2" {
  availability_zone_id = var.aws_subnet-availability_zone_id_1
  cidr_block           = "10.0.2.0/24"
  vpc_id               = aws_vpc.quest-demo.id

  tags = {
    Name = "quest Demo Subnet (ECS 2)"
  }
}

resource "aws_subnet" "quest-demo-subnet-lb-1" {
  availability_zone_id = var.aws_subnet-availability_zone_id_0
  cidr_block           = "10.0.3.0/24"
  vpc_id               = aws_vpc.quest-demo.id

  tags = {
    Name = "quest Demo Subnet (LB 1)"
  }
}

resource "aws_subnet" "quest-demo-subnet-lb-2" {
  availability_zone_id = var.aws_subnet-availability_zone_id_1
  cidr_block           = "10.0.4.0/24"
  vpc_id               = aws_vpc.quest-demo.id

  tags = {
    Name = "quest Demo Subnet (LB 2)"
  }
}

resource "aws_vpc" "quest-demo" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "quest Demo VPC"
  }
}
