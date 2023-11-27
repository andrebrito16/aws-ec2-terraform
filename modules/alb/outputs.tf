output "alb_target_group_arn" {
  description = "value of alb_target_group_arn"
  value       = resource.aws_lb_target_group.application.arn
}

output "alb_security_groups" {
  description = "value of alb_security_groups"
  value       = var.alb_security_groups
}

output "alb_id" {
  description = "value of alb_id"
  value       = resource.aws_lb.this.id
}
output "alb_dns" {
  description = "value of alb_dns"
  value       = resource.aws_lb.this.dns_name
}
