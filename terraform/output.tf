output "quest-demo-node-server" {
  value = module.quest-demo-node-server.public_ip
}

output "quest-demo-ecs-alb" {
  value = "https://${module.quest-demo-ecs.lb_address}"
}
