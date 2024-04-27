resource "aws_ecs_task_definition" "blaze_graphql" {
  family             = "blaze_graphql"
  network_mode       = "awsvpc"
  cpu                = var.cpu
  memory             = var.memory
  execution_role_arn = var.execution_role_arn
  task_role_arn      = var.task_role_arn

  container_definitions = jsonencode([
    {
      name      = "graphql"
      image     = aws_ecr_repository.graphql.repository_url
      essential = true

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.blaze_graphql_logs.name
          awslogs-region        = var.logs_region
          awslogs-stream-prefix = "ecs"
        }
      }

      portMappings = [
        {
          name          = "graphql"
          containerPort = 8080
          hostPort      = 8080
        }
      ]

    },
  ])

  requires_compatibilities = ["FARGATE"]

  tags = {
    name = "blaze_blaze"
  }
}
