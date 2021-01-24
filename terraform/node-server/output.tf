output "name" {
  value = var.name
}

output "secret-word" {
  value = regex("find..(.*).the ", data.http.secret.body)[0]
}

output "public_ip" {
  value = "http://${aws_eip.quest-demo-node-server-eip.public_ip}:3000"
}
