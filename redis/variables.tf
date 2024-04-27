variable "redis_sg" {
  type        = list(string)
  description = "redis security group"
}

variable "redis_subnets" {
  type        = list(string)
  description = "redis subnets"
}
