resource "aws_ecs_service" "setjmp-service" {
  name                   = "setjmp-service"
  cluster                = var.cluster
  task_definition        = aws_ecs_task_definition.setjmp.arn
  desired_count          = var.desired_count
  launch_type            = "FARGATE"
  platform_version       = "LATEST"
  enable_execute_command = "true"

  network_configuration {
    subnets          = var.subnets
    security_groups  = [aws_security_group.setjmp.id]
    assign_public_ip = true
  }

}
