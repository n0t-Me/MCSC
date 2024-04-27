resource "aws_elasticache_cluster" "cache" {
  cluster_id               = "ctfd-cache"
  engine                   = "redis"
  node_type                = "cache.t3.micro"
  num_cache_nodes          = 1
  parameter_group_name     = "default.redis7"
  engine_version           = "7.0"
  port                     = 6379
  security_group_ids       = var.redis_sg
  snapshot_window          = "05:00-09:00"
  snapshot_retention_limit = 0
  subnet_group_name        = aws_elasticache_subnet_group.redis_subnet.name
}

resource "aws_elasticache_subnet_group" "redis_subnet" {
  name       = "ctfd-redis-subnet"
  subnet_ids = var.redis_subnets
}

