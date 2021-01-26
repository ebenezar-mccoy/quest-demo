resource "aws_alb" "application_load_balancer" {
  name               = "${var.name}-lb"
  load_balancer_type = "application"
  subnets            = var.lb-subnets
  security_groups    = var.vpc-security-group-ids
}

resource "aws_lb_target_group" "target_group" {
  name        = "${var.name}-tg"
  port        = 3000
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc-id
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn =  aws_alb.application_load_balancer.arn
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = aws_acm_certificate.cert.arn
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }

  depends_on = [aws_acm_certificate.cert]
}
