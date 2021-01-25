output "name" {
  value = var.name
}

output "public_ip" {
  value = aws_eip.quest-demo-node-server-eip.public_ip
}
