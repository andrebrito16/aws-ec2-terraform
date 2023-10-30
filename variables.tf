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
  default     = "meu-alb"
}

variable "alb_security_groups" {
  description = "Lista de Security Groups para o ALB"
  type        = list(string)
  default     = []
}

# # Variáveis para EC2 e Auto Scaling
# variable "ami_id" {
#   description = "ID da AMI para usar no Launch Configuration"
#   type        = string
# }

# variable "instance_type" {
#   description = "Tipo de instância EC2"
#   default     = "t2.micro"
# }

# variable "asg_min_size" {
#   description = "Tamanho mínimo do Auto Scaling Group"
#   default     = 1
# }

# variable "asg_max_size" {
#   description = "Tamanho máximo do Auto Scaling Group"
#   default     = 3
# }

# # Variáveis para RDS
# variable "rds_instance_class" {
#   description = "Tipo de instância RDS"
#   default     = "db.t2.micro"
# }

# variable "rds_username" {
#   description = "Nome de usuário para o banco de dados RDS"
#   type        = string
# }

# variable "rds_password" {
#   description = "Senha para o banco de dados RDS"
#   type        = string
#   sensitive   = true
# }

# variable "rds_database_name" {
#   description = "Nome do banco de dados no RDS"
#   type        = string
# }

