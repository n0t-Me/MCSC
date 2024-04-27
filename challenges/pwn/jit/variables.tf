variable "vpc_id" {
  type = string
}

variable "subnets" {
  type = list(string)
}

variable "cluster" {
  type = string
}

variable "execution_role_arn" {
  type = string
}

variable "task_role_arn" {
  type = string
}

variable "cpu" {
  type = string
}

variable "memory" {
  type = string
}

variable "desired_count" {
  type    = number
  default = 1
}

variable "logs_region" {
  type    = string
  default = "us-east-1"
}

variable "service_depends_on" {}

variable "cluster_name" {}

