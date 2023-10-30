output "ami_id" {
  description = "ID da AMI selecionada"
  value       = data.aws_ami.selected.id
}
