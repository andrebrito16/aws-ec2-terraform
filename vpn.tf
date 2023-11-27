resource "aws_instance" "vpn-instance" {
  ami           = "ami-0fc5d935ebf8bc3bc"
  instance_type = "t2.small"

  vpc_security_group_ids = [
    module.security_groups.security_group_http_id,
  ]

  subnet_id = module.vpc.public_subnet_ids[0]

  key_name = "MBP Andre pkey"

  user_data = data.template_cloudinit_config.vpn_application.rendered
  iam_instance_profile = module.iam.aws_iam_instance_profile_name 

  tags = {
    Name = "vpn-instance"
  }
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.vpn-instance.id
  allocation_id = "eipalloc-0e69f4a35f558e5a5"
}

# resource "aws_route_table" "private_route_table" {
#   vpc_id = module.vpc.vpc_id

#   route {
#     cidr_block = "0.0.0.0/0"
#     network_interface_id = 
#   }

#   tags = {
#     Name = "private-route-table"
#   }
# }

# resource "aws_route_table_association" "private_subnet_association" {
#   count          = length(module.vpc.private_subnet_ids)
#   subnet_id      = module.vpc.private_subnet_ids[count.index]
#   route_table_id = aws_route_table.private_route_table.id
# }

resource "aws_security_group_rule" "vpn_access" {
  type        = "ingress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["172.16.0.0/16"]  # Update this to match your VPC CIDR or specific subnets
  security_group_id = module.security_groups.security_group_http_id
}


