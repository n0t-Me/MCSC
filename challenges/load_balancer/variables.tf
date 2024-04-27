variable "subnets" {
  type        = list(string)
  description = "Subnets where challs reside"
}

variable "vpc_id" {
  type        = string
  description = "VPC of challs"
}
