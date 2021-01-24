output "lb_address" {
  value = aws_alb.application_load_balancer.dns_name
}
