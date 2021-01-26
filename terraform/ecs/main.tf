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
    subnets          = var.subnets
    assign_public_ip = true
    security_groups  = var.vpc-security-group-ids
  }

  depends_on = [aws_lb_listener.listener, aws_iam_role_policy_attachment.ecsTaskExecutionRole_policy]
}

data "http" "secret" {
  url = "http://${var.node-server-public-ip}:3000"
}

resource "aws_ecs_task_definition" "quest-demo-task" {
  family                   = "${var.name}-task" # Naming our first task
  container_definitions    = <<DEFINITION
  [
    {
      "name": "${var.name}-task",
      "image": "ebenezar/quest-demo",
      "essential": true,
      "portMappings": [
        {
          "containerPort": 3000,
          "hostPort": 3000
        }
      ],
      "environment": [
        {
          "name": "SECRET_WORD",
          "value": "${regex("find..(.*).the ", data.http.secret.body)[0]}"
        }
      ],
      "memory": 512,
      "cpu": 256
    }
  ]
  DEFINITION
  requires_compatibilities = ["FARGATE"] # Stating that we are using ECS Fargate
  network_mode             = "awsvpc"    # Using awsvpc as our network mode as this is required for Fargate
  memory                   = 512         # Specifying the memory our container requires
  cpu                      = 256         # Specifying the CPU our container requires
  execution_role_arn       = aws_iam_role.ecsTaskExecutionRole.arn
}
