resource "aws_launch_template" "ec2_server" {
  name_prefix   = "terraform-lt-ec2-dev"
  image_id      = module.ami_selector.ami_id
  instance_type = "t2.medium"
  user_data     = data.template_cloudinit_config.ec2_application.rendered

  lifecycle {
    create_before_destroy = true
  }

  iam_instance_profile {
    name = module.iam.aws_iam_instance_profile_name
  }

  key_name = "MBP Andre pkey"

  network_interfaces {
    security_groups = [
      module.security_groups.security_group_http_id,
    ]
  }
}
