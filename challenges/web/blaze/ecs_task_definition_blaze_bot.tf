resource "aws_ecs_task_definition" "blaze_bot" {
  family             = "blaze_bot"
  network_mode       = "awsvpc"
  cpu                = var.cpu
  memory             = var.memory
  execution_role_arn = var.execution_role_arn
  task_role_arn      = var.task_role_arn

  depends_on = [aws_ecs_task_definition.blaze_blaze]

  container_definitions = jsonencode([
    {
      name      = "blaze_bot"
      image     = aws_ecr_repository.blaze_bot.repository_url
      essential = true

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.blaze_bot_logs.name
          awslogs-region        = var.logs_region
          awslogs-stream-prefix = "ecs"
        }
      }
    },
  ])

  requires_compatibilities = ["FARGATE"]

  tags = {
    name = "blaze_bot"
  }
}
