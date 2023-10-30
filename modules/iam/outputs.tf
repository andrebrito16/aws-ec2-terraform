output "aws_iam_instance_profile_name" {
  description = "value of aws_iam_instance_profile"
  value       = aws_iam_instance_profile.ec2_instance_profile.name
}
