resource "aws_ecs_task_definition" "ez" {
  family             = "ez"
  network_mode       = "awsvpc"
  cpu                = var.cpu
  memory             = var.memory
  execution_role_arn = var.execution_role_arn
  task_role_arn      = var.task_role_arn

  container_definitions = jsonencode([
    {
      name      = "ez"
      image     = aws_ecr_repository.ez.repository_url
      essential = true

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.ez.name
          awslogs-region        = var.logs_region
          awslogs-stream-prefix = "ecs"
        }
      }

      portMappings = [
        {
          name          = "ez"
          containerPort = 3000
          hostPort      = 3000
        }
      ]

    },
  ])

  requires_compatibilities = ["FARGATE"]

  tags = {
    name = "ez"
  }
}
