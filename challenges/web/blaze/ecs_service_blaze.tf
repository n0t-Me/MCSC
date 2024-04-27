resource "aws_ecs_service" "blaze-service" {
  name                   = "blaze-service"
  cluster                = var.cluster
  task_definition        = aws_ecs_task_definition.blaze_blaze.arn
  desired_count          = var.desired_count
  launch_type            = "FARGATE"
  platform_version       = "LATEST"
  enable_execute_command = "true"

  network_configuration {
    subnets          = var.subnets
    security_groups  = [aws_security_group.blaze.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.blaze.arn
    container_name   = "blaze"
    container_port   = 80
  }

  service_connect_configuration {
    enabled   = true
    namespace = var.cluster_name
    service {
      discovery_name = "nginx"
      port_name      = "nginx"
      client_alias {
        dns_name = "nginx"
        port     = 80
      }
    }
  }

}
