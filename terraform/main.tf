module "quest-demo-node-server" {
  source               = "./node-server"
  name                 = "quest-demo-node-server"
  ami-id               = "ami-0be2609ba883822ec"
  key-pair             = aws_key_pair.quest-demo-key.key_name
  subnet-id            = aws_subnet.quest-demo-subnet-public.id
  vpc-security-group-ids = [
    aws_security_group.allow-http.id,
    aws_security_group.allow-ssh.id,
    aws_security_group.allow-all-outbound.id
  ]
}

module "quest-demo-ecs" {
  source = "./ecs"
  name                = "quest-demo-ecs"
  vpc_id              = aws_vpc.quest-demo.id
  vpc_zone_identifier = [aws_subnet.quest-demo-subnet-public.id]
  subnets             = [aws_subnet.quest-demo-subnet-private-1.id, aws_subnet.quest-demo-subnet-private-2.id]
  vpc-security-group-ids = [
    aws_security_group.allow-http.id,
    aws_security_group.allow-all-outbound.id
  ]
  secret_word = module.quest-demo-node-server.secret-word
  depends_on = [module.quest-demo-node-server]
}
