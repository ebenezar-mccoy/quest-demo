module "quest-demo-node-server" {
  source    = "./node-server"
  name      = "quest-demo-node-server"
  ami-id    = "ami-0be2609ba883822ec"
  key-pair  = aws_key_pair.quest-demo-key.key_name
  subnet-id = aws_subnet.quest-demo-subnet-node-server.id
  vpc-security-group-ids = [
    aws_security_group.allow-http.id,
    aws_security_group.allow-ssh.id,
    aws_security_group.allow-all-outbound.id
  ]
}

module "quest-demo-ecs" {
  source        = "./ecs"
  name          = "quest-demo-ecs"
  vpc-id        = aws_vpc.quest-demo.id
  desired_count = 2
  subnets = [
    aws_subnet.quest-demo-subnet-ecs-1.id,
    aws_subnet.quest-demo-subnet-ecs-2.id
  ]
  vpc-security-group-ids = [
    aws_security_group.allow-http.id,
    aws_security_group.allow-all-outbound.id
  ]
  node-server-public-ip = module.quest-demo-node-server.public_ip
  depends_on            = [module.quest-demo-node-server]
}
