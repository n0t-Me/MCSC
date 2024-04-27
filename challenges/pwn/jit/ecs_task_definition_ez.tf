resource "aws_ecs_task_definition" "jit" {
  family             = "jit"
  network_mode       = "awsvpc"
  cpu                = var.cpu
  memory             = var.memory
  execution_role_arn = var.execution_role_arn
  task_role_arn      = var.task_role_arn

  container_definitions = jsonencode([
    {
      name                   = "jit"
      image                  = aws_ecr_repository.jit.repository_url
      essential              = true
      readonlyRootFilesystem = true

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.jit.name
          awslogs-region        = var.logs_region
          awslogs-stream-prefix = "ecs"
        }
      }

      portMappings = [
        {
          name          = "jit"
          containerPort = 5000
          hostPort      = 5000
        }
      ]

    },
  ])

  requires_compatibilities = ["FARGATE"]

  tags = {
    name = "jit"
  }
}
