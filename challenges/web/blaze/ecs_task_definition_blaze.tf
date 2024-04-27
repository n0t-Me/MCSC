resource "aws_ecs_task_definition" "blaze_blaze" {
  family             = "blaze_blaze"
  network_mode       = "awsvpc"
  cpu                = var.cpu
  memory             = var.memory
  execution_role_arn = var.execution_role_arn
  task_role_arn      = var.task_role_arn

  depends_on = [aws_ecs_task_definition.blaze_graphql]

  container_definitions = jsonencode([
    {
      name      = "blaze"
      image     = aws_ecr_repository.blaze.repository_url
      essential = true

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.blaze_blaze_logs.name
          awslogs-region        = var.logs_region
          awslogs-stream-prefix = "ecs"
        }
      }

      portMappings = [
        {
          name          = "nginx"
          containerPort = 80
          hostPort      = 80
        }
      ]

    },
  ])

  requires_compatibilities = ["FARGATE"]

  tags = {
    name = "blaze_blaze"
  }
}
