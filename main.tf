terraform {
  backend "s3" {
    bucket  = "ab-terraform-bucket-state"
    key     = "tf-states/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}

provider "aws" {
  region = var.region
}

module "iam" {
  source = "./modules/iam"
}

module "vpc" {
  source = "./modules/private-vpc"
  vpn-instance-id = aws_instance.vpn-instance.id
}

module "security_groups" {
  source = "./modules/security_groups"
  vpc_id = module.vpc.vpc_id
}

module "alb" {
  source  = "./modules/alb"
  vpc_id  = module.vpc.vpc_id
  subnets = module.vpc.public_subnet_ids
  name    = var.alb_name
  alb_security_groups = [
    module.security_groups.security_group_http_id,
  ]
}

module "ami_selector" {
  source = "./modules/ami_selector"
}

module "ec2" {
  source               = "./modules/ec2"
  alb_target_group_arn = module.alb.alb_target_group_arn
  ami_id               = module.ami_selector.ami_id
  vpc_zone_identifier  = module.vpc.private_subnet_ids
  launch_template_id   = aws_launch_template.ec2_server.id
  load_balancer_name   = var.alb_name
  load_balancer_id     = module.alb.alb_id
}

#  d

output "alb_dns" {
  value = module.alb.alb_dns
}
