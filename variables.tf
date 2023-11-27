# variables.tf

# Variáveis gerais
variable "region" {
  description = "Região da AWS onde os recursos serão criados"
  default     = "us-east-1"
}

variable "environment" {
  description = "Ambiente (dev, staging, prod)"
  default     = "dev"
}

# Variáveis para ALB
variable "alb_name" {
  description = "Nome para o Application Load Balancer"
  default     = "andre-alb"
}

variable "alb_security_groups" {
  description = "Lista de Security Groups para o ALB"
  type        = list(string)
  default     = []
}

