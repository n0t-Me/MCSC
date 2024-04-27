variable "cpu" {
  type        = string
  description = "CPU to allocate for CTFd"
}

variable "memory" {
  type        = string
  description = "MB of memory for CTFd"
}

variable "execution_role_arn" {
  type        = string
  description = "Execution role of task"
}

variable "task_role_arn" {
  type        = string
  description = "Task role"
}

variable "ctfd_version" {
  type        = string
  description = "Version of CTFd"
}

variable "redis_url" {
  type        = string
  description = "Endpoint of redis instance"
}

variable "database_url" {
  type        = string
  description = "MySQL instance URL"
}

variable "workers" {
  type        = string
  description = "Number of gunicorn workers for CTFd"
}

variable "logs_region" {
  type        = string
  description = "Logs region"
}


variable "ecs_task_depends_on" {
  type        = any
  description = "List of res to be created before task"
  default     = null
}

variable "desired_count" {
  type        = number
  description = "Number of instances of ctfd"
  default     = 1
}

variable "subnets" {
  type        = list(string)
  description = "Subnets for CTFd service"
}

variable "security_groups" {
  type        = list(string)
  description = "Security groups for CTFd"
}

variable "target_group_arn" {
  type        = string
  description = "ARN for load blancer target group"
}

variable "fs_id" {}
variable "fs_access_point" {}

