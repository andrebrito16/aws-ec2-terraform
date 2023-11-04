output "security_group_http_id" {
  description = "value of the security group http id"
  value       = aws_security_group.alb_ec2_sg.id
}
