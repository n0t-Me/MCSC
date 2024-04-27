variable "vpc_id" {
  description = "id for the vpc where the db lives"
  type        = string
}

variable "allocated_storage" {
  description = "GB of storage for db"
  type        = number
  default     = 10
}

variable "db_subnets" {
  description = "subnets where the db lives"
  type        = list(string)
}

variable "sg_ids" {
  description = "ids for security groups"
  type        = list(string)
}
