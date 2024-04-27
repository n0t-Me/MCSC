resource "aws_ecs_service" "warmup-service" {
  name                   = "warmup-service"
  cluster                = var.cluster
  task_definition        = aws_ecs_task_definition.warmup.arn
  desired_count          = var.desired_count
  launch_type            = "FARGATE"
  platform_version       = "LATEST"
  enable_execute_command = "true"

  network_configuration {
    subnets          = var.subnets
    security_groups  = [aws_security_group.warmup.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.warmup.arn
    container_name   = "warmup"
    container_port   = 3000
  }
}
