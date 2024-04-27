variable "subnets" {
  type        = list(string)
  description = "EFS subnets"
}

variable "vpc_id" {
  type        = string
  description = "CTFd VPC id"
}

