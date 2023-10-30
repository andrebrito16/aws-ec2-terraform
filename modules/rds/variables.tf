variable "security_groups_ids" {
  description = "value of the security group ids"
  type        = list(string)
}

variable "rds_subnet_ids" {
  description = "value of the rds subnet ids"
  type        = list(string)
}
