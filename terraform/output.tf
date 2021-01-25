output "quest-demo-node-server" {
  value =  "http://${module.quest-demo-node-server.public_ip}:3000" 
}

output "quest-demo-ecs-alb" {
  value = "https://${module.quest-demo-ecs.lb_address}"
}
