resource "aws_ecs_cluster" "ctfd-cluster" {
  name = "ctfd-cluster"
  setting {
    name  = "containerInsights"
    value = "disabled"
  }

}
