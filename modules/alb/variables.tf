variable "name" {
  default     = "alb-main"
  description = "Application Load Balancer name"
}


variable "alb_security_groups" {
  type        = list(string)
  description = "value of alb_security_groups"
}

variable "vpc_id" {
  description = "ID do VPC onde o ALB será criado"
  type        = string
}

variable "subnets" {
  description = "Lista de IDs das subnets onde o ALB será criado"
  type        = list(string)
}
