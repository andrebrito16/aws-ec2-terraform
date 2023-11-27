data "template_cloudinit_config" "ec2_application" {
  gzip          = true
  base64_encode = true

  part {
    filename     = "install-with-docker.sh"
    content_type = "text/x-shellscript"
    content = templatefile("${path.module}/app/scripts/install-with-docker.sh", {
      # POSTGRES_CONNECTION_STRING = module.rds.postgres_connection_string,
      POSTGRES_CONNECTION_STRING = "postgres://admin:admin@${resource.aws_instance.vpn-instance.private_ip}:5432/app?sslmode=disable",
    })
  }
}

data "template_cloudinit_config" "vpn_application" {
  gzip          = true
  base64_encode = true

  part {
    filename     = "setup-vpn-server.sh"
    content_type = "text/x-shellscript"
    content      = templatefile("${path.module}/app/scripts/setup-vpn-server.sh", {})
  }
}
