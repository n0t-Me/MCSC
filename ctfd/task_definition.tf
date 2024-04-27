resource "aws_ecs_task_definition" "ctfd_task" {
  family             = "ctfd"
  network_mode       = "awsvpc"
  cpu                = var.cpu
  memory             = var.memory
  execution_role_arn = var.execution_role_arn
  task_role_arn      = var.task_role_arn

  depends_on = [var.ecs_task_depends_on]

  container_definitions = jsonencode([
    {
      name      = "ctfd"
      image     = aws_ecr_repository.ctfd.repository_url
      essential = true
      linux_parameter = {
        init_process_enable = "true"
      }

      "environment" : [
        { "name" : "SECRET_KEY", "value" : "5d6e1f685f50693522318ae7b396fc4d5f488f25753fb1ba6c4bb3af117316c8" },
        { "name" : "REDIS_URL", "value" : "${var.redis_url}" },
        { "name" : "REVERSE_PROXY", "value" : "true" },
        { "name" : "DATABASE_URL", "value" : "${var.database_url}" },
        { "name" : "WORKERS", "value" : "${var.workers}" },
        { "name" : "UPLOAD_FOLDER", "value" : "/var/CTFd/uploads" },
        { "name" : "LOG_FOLDER", "value" : "/var/CTFd/logs" },
        { "name" : "DISCORD_WEBHOOK_URL", "value" : "https://discord.com/api/webhooks/1221333779088412773/_mERCMTL8-2CF3AMuPFqGLJCGwLVk2ea14VjmbVuO6zC7jd2L8goQYDhMzRc4HRdGbXw" },
        { "name" : "DISCORD_WEBHOOK_MESSAGE", "value" : "## @everyone Tbarklah 3la **{team}** 💪: **{fsolves}** solution on **{challenge}**" },
        { "name" : "DISCORD_FIRSTBLOOD_MESSAGE", "value" : "## @everyone **{team}** just got first blood 🩸 on **{challenge}** !! 😎" }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.ctfd_logs.name
          awslogs-region        = var.logs_region
          awslogs-stream-prefix = "ecs"
        }
      }

      portMappings = [
        {
          containerPort = 8000
          hostPort      = 8000
        }
      ]

      mountPoints = [
        {
          containerPath = "/var/CTFd/"
          sourceVolume  = "ctfd-efs"
        }
      ]

    },
  ])

  volume {
    name = "ctfd-efs"

    efs_volume_configuration {
      file_system_id     = var.fs_id
      transit_encryption = "ENABLED"
      authorization_config {
        access_point_id = var.fs_access_point
        iam             = "ENABLED"
      }
    }
  }

  requires_compatibilities = ["FARGATE"]

  tags = {
    name         = "ctfd"
    ctfd_version = var.ctfd_version
  }
}
