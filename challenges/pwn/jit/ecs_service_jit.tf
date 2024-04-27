resource "aws_ecs_service" "jit-service" {
  name                   = "jit-service"
  cluster                = var.cluster
  task_definition        = aws_ecs_task_definition.jit.arn
  desired_count          = var.desired_count
  launch_type            = "FARGATE"
  platform_version       = "LATEST"
  enable_execute_command = "true"

  network_configuration {
    subnets          = var.subnets
    security_groups  = [aws_security_group.jit.id]
    assign_public_ip = true
  }

}
