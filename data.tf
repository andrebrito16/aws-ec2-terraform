data "template_cloudinit_config" "ec2_application" {
  gzip          = true
  base64_encode = true
  part {
    filename = "text/x-shellscript"
    content = templatefile("${path.module}/app/scripts/install.sh", {
      NGINX_CONF = "/etc/nginx/sites-available/default"
    })
  }
}
