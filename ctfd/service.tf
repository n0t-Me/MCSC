resource "aws_ecs_service" "ctfd-service" {
  name                   = "ctfd-service"
  cluster                = aws_ecs_cluster.ctfd-cluster.id
  task_definition        = aws_ecs_task_definition.ctfd_task.arn
  desired_count          = var.desired_count
  launch_type            = "FARGATE"
  platform_version       = "LATEST"
  enable_execute_command = "true"

  network_configuration {
    subnets          = var.subnets
    security_groups  = var.security_groups
    assign_public_ip = true
  }


  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "ctfd"
    container_port   = 8000
  }

}
