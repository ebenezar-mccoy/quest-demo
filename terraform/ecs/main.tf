resource "aws_ecs_cluster" "quest-demo-ecs" {
  name = var.name
}

resource "aws_ecs_service" "quest-demo-ecs" {
  name            = "${var.name}-ecs_service"
  cluster         = aws_ecs_cluster.quest-demo-ecs.id
  task_definition = aws_ecs_task_definition.quest-demo-task.arn
  launch_type     = "FARGATE"
  desired_count   = var.desired_count

  load_balancer {
    target_group_arn = aws_lb_target_group.target_group.arn
    container_name   = aws_ecs_task_definition.quest-demo-task.family
    container_port   = 3000
  }

  network_configuration {
    subnets          = var.ecs-subnets
    assign_public_ip = true
    security_groups  = var.vpc-security-group-ids
  }
}

data "http" "secret" {
  url = "http://${var.node-server-public-ip}:3000"
}

data "template_file" "quest-demo-task-definition" {
  template = file("${path.module}/task-definition/quest-demo-task-definition.json")
  vars = {
    task_name   = "${var.name}-task"
    secret_word = regex("find..(.*).the ", data.http.secret.body)[0]
  }
}

resource "aws_ecs_task_definition" "quest-demo-task" {
  family                   = "${var.name}-task"
  container_definitions    = data.template_file.quest-demo-task-definition.rendered
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"    # Using awsvpc as our network mode as this is required for Fargate
  memory                   = 512
  cpu                      = 256
  execution_role_arn       = aws_iam_role.ecsTaskExecutionRole.arn
}
