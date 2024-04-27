resource "aws_ecs_task_definition" "warmup" {
  family             = "warmup"
  network_mode       = "awsvpc"
  cpu                = var.cpu
  memory             = var.memory
  execution_role_arn = var.execution_role_arn
  task_role_arn      = var.task_role_arn

  container_definitions = jsonencode([
    {
      name      = "warmup"
      image     = aws_ecr_repository.warmup.repository_url
      essential = true

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.warmup.name
          awslogs-region        = var.logs_region
          awslogs-stream-prefix = "ecs"
        }
      }

      portMappings = [
        {
          name          = "warmup"
          containerPort = 3000
          hostPort      = 3000
        }
      ]

    },
  ])

  requires_compatibilities = ["FARGATE"]

  tags = {
    name = "warmup"
  }
}
