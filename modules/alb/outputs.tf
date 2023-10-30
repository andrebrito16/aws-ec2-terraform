output "alb_target_group_arn" {
  description = "value of alb_target_group_arn"
  value       = resource.aws_lb_target_group.this.arn
}

output "alb_security_groups" {
  description = "value of alb_security_groups"
  value       = var.alb_security_groups
}
