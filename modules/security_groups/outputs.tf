output "security_group_http_id" {
  description = "value of the security group http id"
  value       = aws_security_group.alb_http_sg.id
}

output "security_group_https_id" {
  description = "value of the security group https id"
  value       = aws_security_group.alb_https_sg.id
}

output "security_group_application_id" {
  description = "value of the security group application id"
  value       = aws_security_group.application_sg.id
}
