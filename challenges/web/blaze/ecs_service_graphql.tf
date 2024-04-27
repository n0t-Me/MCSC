resource "aws_ecs_service" "graphql-service" {
  name                   = "graphql-service"
  cluster                = var.cluster
  task_definition        = aws_ecs_task_definition.blaze_graphql.arn
  desired_count          = var.desired_count
  launch_type            = "FARGATE"
  platform_version       = "LATEST"
  enable_execute_command = "true"

  network_configuration {
    subnets          = var.subnets
    security_groups  = [aws_security_group.graphql.id]
    assign_public_ip = true
  }

  service_connect_configuration {
    enabled   = true
    namespace = var.cluster_name
    service {
      discovery_name = "graphql"
      port_name      = "graphql"
      client_alias {
        dns_name = "graphql"
        port     = 8080
      }
    }
  }

}
