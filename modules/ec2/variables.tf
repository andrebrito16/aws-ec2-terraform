# Variáveis para EC2 e Auto Scaling
variable "ami_id" {
  description = "ID da AMI para usar no Launch Configuration"
  type        = string
}

variable "instance_type" {
  description = "Tipo de instância EC2"
  default     = "t2.micro"
}

variable "asg_min_size" {
  description = "Tamanho mínimo do Auto Scaling Group"
  default     = 1
}

variable "asg_max_size" {
  description = "Tamanho máximo do Auto Scaling Group"
  default     = 3
}

variable "alb_target_group_arn" {
  description = "ARN do Target Group do ALB"
  type        = string
}

variable "vpc_zone_identifier" {
  description = "Lista de subnets para o Auto Scaling Group"
  type        = list(string)
}

variable "alb_security_groups" {
  type        = list(string)
  default     = []
  description = "value of alb_security_groups"
}

variable "aws_instance_profile_name" {
  description = "name of aws_instance_profile"
  type        = string
  default     = "teste"
}

variable "launch_template_id" {
  description = "id of launch_template"
  type        = string
}
